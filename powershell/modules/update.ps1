Push-Location "$PSScriptRoot"
try {
    [System.IO.FileInfo] $packagesConfigFile = Get-Item "packages.config"
    [System.Xml.XmlDocument] $packagesConfig = [System.Xml.XmlDocument](Get-Content -Raw $packagesConfigFile.FullName)
    foreach ($package in $packagesConfig.packages.package) {
        [string] $versionInstalled = $package.Attributes["version"].Value
        [string] $versionLatest = (nuget list $package.id -Source https://www.powershellgallery.com/api/v2 | Where-Object { ($_ -split " ")[0] -eq $package.id } | Select-Object -First 1).Split(" ")[1]
        if ($versionInstalled -ne $versionLatest) {
            Write-Host "Updating $($package.id) from $versionInstalled to $versionLatest"
            $package.Attributes["version"].Value = $versionLatest
            $packagesConfig.Save($packagesConfigFile.FullName)
        }
    }
}
finally {
    Pop-Location
}
