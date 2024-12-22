if (-not (Get-Command nuget -ErrorAction SilentlyContinue)) {
    throw "NuGet is not installed. Please install it from https://www.nuget.org/downloads."
}


Push-Location "$PSScriptRoot"
[System.Collections.Generic.Dictionary[string, string]] $latestPSGalleryPackageVersions = @{}
function Get-PSGalleryPackageVersionLatest($packageId) {
    if ($latestPSGalleryPackageVersions.ContainsKey($packageId)) {
        return $latestPSGalleryPackageVersions[$packageId]
    }

    [string[]] $nugetListResult = $(nuget search $packageId -Source "https://www.powershellgallery.com/api/v2")
    [string] $noResultsMessage = "No results found."

    [int] $tries = 4
    while ($tries -gt 0 -and ($noResultsMessage -in $nugetListResult)) {
        Write-Information "PSGallery is being uncooperative. Retrying in 3 seconds. ($tries tries remaining)"
        Start-Sleep -Seconds 3

        $tries--
        $nugetListResult = $(nuget search $packageId -Source "https://www.powershellgallery.com/api/v2")
    }
    if ($noResultsMessage -in $nugetListResult) {
        throw "PSGallery (repeatedly) returned `"$noResultsMessage`" when searching for package '$packageId'."
    }

    $matchingPackageEntry = $nugetListResult | Where-Object { $_ -imatch "^>\s"+[regex]::Escape($packageId)+"\s" } | Select-Object -First 1
    if (-not $matchingPackageEntry) {
        throw "PSGallery search for '$packageId' only returned inexact matches."
    }

    $latestPSGalleryPackageVersions[$packageId] = $matchingPackageEntry.Split(" ")[3]
    return $latestPSGalleryPackageVersions[$packageId]
}

try {
    [System.IO.FileInfo] $packagesConfigFile = Get-Item "packages.config"
    [System.Xml.XmlDocument] $packagesConfig = [System.Xml.XmlDocument](Get-Content -Raw $packagesConfigFile.FullName)
    foreach ($package in $packagesConfig.packages.package) {
        [string] $versionInstalled = $package.Attributes["version"].Value
        [string] $versionLatest = Get-PSGalleryPackageVersionLatest -packageId $package.id
        if ($versionInstalled -ne $versionLatest) {
            Write-Host "Updating $($package.id) from $versionInstalled to $versionLatest"
            $package.Attributes["version"].Value = $versionLatest
            $packagesConfig.Save($packagesConfigFile.FullName)
        }
    }

    ./restore.ps1
}
finally {
    Pop-Location
}
