if (-not (Get-Command "nuget" -ErrorAction SilentlyContinue)) {
    throw "NuGet is not installed. Please install it from https://www.nuget.org/downloads."
}

Push-Location $PSScriptRoot
try {
    $ds = [System.IO.Path]::DirectorySeparatorChar

    Write-Verbose "Deleting the .trash folder if it exists."
    [string] $trashPath = "..${ds}.trash"
    if (Test-Path $trashPath -ErrorAction SilentlyContinue) {
        Remove-Item $trashPath -Recurse -Force | Out-Null
    }

    Write-Verbose "Deleting all package folders if they exist."
    Get-ChildItem -Path $PSScriptRoot -Directory | Remove-Item -Recurse -Force -ErrorAction Stop | Out-Null

    Write-Verbose "Run a NuGet restore, will throw if it fails."
    [string[]] $nugetError = $(nuget restore -ConfigFile "NuGet.config" | Out-Null) 2>&1
    if ($LASTEXITCODE -ne 0) {
        if ($nugetError) {
            throw ("nuget restore failed, exited with code $LASTEXITCODE." + [Environment]::NewLine + $nugetError)
        } else {
            throw "nuget restore failed, exited with code $LASTEXITCODE."
        }
    }

    Write-Verbose "Deleting the .git folders that NuGet sometimes makes, depending on package contents."
    Get-ChildItem -Path $PSScriptRoot -Filter ".git" -Directory -Recurse | Remove-Item -Recurse -Force | Out-Null

    Write-Verbose "Make sure the package folders have names with the correct casing."
    # NuGet sometimes does the restore with the wrong casing - while simultaneously caching (in our ".trash" folder) the correct casing.
    # We'll move the folders around to make sure they have the correct casing.
    [xml] $packagesConfig = [xml](Get-Content -Raw "packages.config")
    foreach ($package in $packagesConfig.packages.package) {
        Write-Verbose "Checking folder casing for package: $($package.id)"

        [System.IO.DirectoryInfo] $packageFolder = Get-ChildItem -Path $PSScriptRoot -Directory | Where-Object { $_.Name -ieq $package.id } | Select-Object -First 1
        if (-not $packageFolder) {
            throw "Package folder not found: $($package.id)"
        }

        [string] $packageVersionSlug = "$($package.id).$($package.version)"
        [System.IO.DirectoryInfo] $trashPackageFolder = Get-ChildItem -Path $trashPath -Directory | Where-Object { $_.Name -ieq $packageVersionSlug } | Select-Object -First 1
        if (-not $trashPackageFolder) {
            throw "Package folder not found repositoryFolder ('.trash'): $packageVersionSlug"
        }

        Write-Verbose "Deleting the metadata files that NuGet leaves for us."
        foreach ($packageVersionSubfolder in Get-ChildItem -Path $packageFolder.Name -Directory) {
            Get-ChildItem -Path $packageVersionSubfolder.FullName -Filter "*.nupkg" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionSubfolder.FullName -Filter "*.nupkg.sha512" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionSubfolder.FullName -Filter "*.nuspec" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionSubfolder.FullName -Filter ".nupkg.metadata" -File | Remove-Item -Force | Out-Null
        }

        [string] $correctlyCasedPackageName = $trashPackageFolder.Name -ireplace "\.$([regex]::Escape($package.version))$", ""
        if ($packageFolder.Name -cne $correctlyCasedPackageName) {
            # Move the folder around to make sure it has the correct casing.
            [string] $temporaryPackageFolderName = "x" + $packageFolder.Name
            Write-Verbose "Moving package folder from '$($packageFolder.Name)' to '$temporaryPackageFolderName'."
            Move-Item -Path $packageFolder.Name -Destination $temporaryPackageFolderName -Force -ErrorAction Stop | Out-Null
            Write-Verbose "Moving package folder from '$temporaryPackageFolderName' to '$correctlyCasedPackageName'."
            Move-Item -Path $temporaryPackageFolderName -Destination $correctlyCasedPackageName -Force -ErrorAction Stop | Out-Null

            if (Get-Command git -ErrorAction SilentlyContinue) {
                # Again, but with git this time.
                [string] $gitRepoRootFullPath = $(git root)
                [string] $packageFolderGitPath = $packageFolder.FullName -ireplace [regex]::Escape($gitRepoRootFullPath), ""
                [string] $temporaryPackageFolderGitPath = $packageFolderGitPath -ireplace ([regex]::Escape($packageFolder.Name) + "$"), $temporaryPackageFolderName
                [string] $correctlyCasedPackageNameGitPath = $packageFolderGitPath -ireplace ([regex]::Escape($packageFolder.Name) + "$"), $correctlyCasedPackageName
                Write-Verbose "Git-moving package folder from '$packageFolderGitPath' to '$temporaryPackageFolderGitPath'."
                git mv $packageFolderGitPath $temporaryPackageFolderGitPath 2>&1 | Out-Null
                Write-Verbose "Git-moving package folder from '$temporaryPackageFolderGitPath' to '$correctlyCasedPackageNameGitPath'."
                git mv $temporaryPackageFolderGitPath $correctlyCasedPackageNameGitPath 2>&1 | Out-Null
            }
        }
    }

    Write-Verbose "Deleting the .trash folder if it exists (again)."
    [string] $trashPath = "..${ds}.trash"
    if (Test-Path $trashPath -ErrorAction SilentlyContinue) {
        Remove-Item $trashPath -Recurse -Force | Out-Null
    }
}
finally {
    Pop-Location
}
