if (-not (Get-Command "nuget" -ErrorAction SilentlyContinue)) {
    throw "NuGet executable not found."
}

$ds = [System.IO.Path]::DirectorySeparatorChar
if (Test-Path "${PSScriptRoot}${ds}..${ds}.trash" -ErrorAction SilentlyContinue) {
    Remove-Item "${PSScriptRoot}${ds}..${ds}.trash" -Recurse -Force | Out-Null
}

Push-Location "$PSScriptRoot"
try {
    nuget restore -ConfigFile "${PSScriptRoot}${ds}NuGet.config"

    Get-ChildItem -Path $PSScriptRoot -Filter ".git" -Directory -Recurse | Remove-Item -Recurse -Force | Out-Null

    # Make sure the package folders have names with the correct casing.
    [xml] $packagesConfig = [xml](Get-Content -Raw "packages.config")
    foreach ($package in $packagesConfig.packages.package) {
        [System.IO.DirectoryInfo] $packageFolder = Get-ChildItem -Path ${PSScriptRoot} -Directory | Where-Object { $_.Name -ieq $package.id } | Select-Object -First 1
        if ($packageFolder) {
            if ($packageFolder.Name -ne $package.id) {
                Move-Item -Path $packageFolder.Name -Destination "x"+$packageFolder.Name -Force | Out-Null
                Move-Item -Path "x"+$packageFolder.Name -Destination $package.id -Force | Out-Null
            }
        } else {
            $packageFolder = Get-ChildItem -Path $PSScriptRoot${ds}..${ds}.trash -Directory | Where-Object { $_.Name -ilike "$($package.id).*" } | Select-Object -First 1
            if (-not $packageFolder) {
                throw "Package folder not found: $($package.id)"
            }
            [string] $packageVersion = $packageFolder.Name -replace "$($package.id)\.", ""
            mkdir $package.id | Out-Null
            Move-Item -Path $packageFolder.FullName -Destination "${PSScriptRoot}${ds}$($package.id)${ds}${packageVersion}" -Force | Out-Null
            Write-Host "Moved ../.trash/$($packageFolder.Name) to ${PSScriptRoot}${ds}$($package.id)${ds}${packageVersion}"
        }
    }
}
finally {
    Pop-Location
}
