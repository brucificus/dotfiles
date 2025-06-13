#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Get-Command "nuget" -ErrorAction SilentlyContinue)) {
    throw "NuGet is not installed. Please install it from https://www.nuget.org/downloads."
}

Push-Location $PSScriptRoot
try {
    $ds = [System.IO.Path]::DirectorySeparatorChar

    [string] $trashPath = "..${ds}.trash" # repositoryPath
    [string] $packagesPath = "." # globalPackagesFolder

    if (Test-Path $trashPath -ErrorAction SilentlyContinue) {
        Write-Verbose "The repositoryPath ('$trashPath') folder exists, deleting it."
        Remove-Item $trashPath -Recurse -Force | Out-Null
    }

    [string] $gitRepoRootFullPath = $null
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitRepoRootFullPath = $(git root)
    }

    Write-Verbose "Deleting all package folders if they exist."
    foreach ($packageFolder in Get-ChildItem -Path $PSScriptRoot -Directory) {
        Remove-Item $packageFolder -Recurse -Force | Out-Null

        if ($gitRepoRootFullPath) {
            # Again, but with git this time.
            [string] $packageFolderGitPath = $packageFolder -ireplace [regex]::Escape($gitRepoRootFullPath), ""
            Write-Verbose "Git-deleting package folder '$packageFolderGitPath'."
            git rm -r $packageFolderGitPath 2>&1 | Out-Null
        }
    }
    Get-ChildItem -Path $packagesPath -Directory | Remove-Item -Recurse -Force -ErrorAction Stop | Out-Null

    Write-Verbose "Running a NuGet restore."
    [string[]] $nugetError = $(nuget restore -ConfigFile "NuGet.config" | Out-Null) 2>&1
    if ($LASTEXITCODE -ne 0) {
        if ($nugetError) {
            throw ("NuGet restore failed, exited with code $LASTEXITCODE." + [Environment]::NewLine + $nugetError)
        } else {
            throw "NuGet restore failed, exited with code $LASTEXITCODE."
        }
    } elseif ($nugetError) {
        Write-Warning "NuGet restore exited with code $LASTEXITCODE, but had some output to stderr:`n$nugetError"
    }

    Write-Verbose "Deleting the .git folders that NuGet sometimes makes, depending on package contents."
    Get-ChildItem -Path $packagesPath -Filter ".git" -Directory -Recurse | Remove-Item -Recurse -Force | Out-Null

    Write-Verbose "Rearranging PSGallery NuGet package folders to align with PowerShell module conventions…"
    # NuGet sometimes does the restore with the wrong casing - while simultaneously caching (in our repositoryPath ".trash" folder) the correct casing.
    # We'll move the folders around to make sure they have the correct casing.
    [xml] $packagesConfig = [xml](Get-Content -Raw "packages.config")
    foreach ($package in $packagesConfig.packages.package) {
        [string] $packageName = $package.id
        Write-Verbose "Arranging folder for package: $packageName"

        [string] $packageVersion = $package.version
        [string] $packageNameVersionSlug = "$packageName.$packageVersion"
        [System.IO.DirectoryInfo] $trashPackageFolder = Get-ChildItem -Path $trashPath -Directory | Where-Object { $_.Name -ieq $packageNameVersionSlug } | Select-Object -First 1
        if ($trashPackageFolder) {
            Write-Verbose "Found a folder in the repositoryPath ('$trashPath') folder for package '$packageName' at version '$packageVersion'."
         } else { # (-not $trashPackageFolder)
            Write-Warning "Could not find a folder in the repositoryPath ('$trashPath') folder for package '$packageName' at version '$packageVersion'. Did a different version restore from NuGet?"
            Write-Information "Assuming a different version restored from NuGet."

            $trashPackageFolder = Get-ChildItem -Path $trashPath -Directory | Where-Object { $_.Name -ilike "${packageName}.*" } | Sort-Object -Property Name -Descending | Select-Object -First 1
            if ($trashPackageFolder) {
                Write-Warning "Guessing this folder in the repositoryPath ('$trashPath') folder is for '$packageName', just a different version: '$($trashPackageFolder.Name)'"
                $packageNameVersionSlug = $trashPackageFolder.Name
                $packageVersion = $packageNameVersionSlug -ireplace "^$([regex]::Escape($packageName))\.", ""
            } else {
                Write-Warning "Could not find a folder in the repositoryPath ('$trashPath') folder for package '$packageName', for any version. Did a NuGet restore fail?"
                Write-Error "Aborting in case we missed a NuGet failure."
                break
            }
        }

        [System.IO.DirectoryInfo] $packageFolder = Get-ChildItem -Path $PSScriptRoot -Directory | Where-Object { $_.Name -ieq $package.id } | Select-Object -First 1
        if (-not $packageFolder) {
            $packageFolder = [System.IO.DirectoryInfo]::new("${PSScriptRoot}${ds}${packageName}")
            $packageFolder.Create()
        }

        # Move the folder around to make sure it has the correct casing.
        [string] $correctlyCasedPackageName = $trashPackageFolder.Name -ireplace "\.$([regex]::Escape($packageVersion))$", ""
        if ($packageFolder.Exists -and ($packageFolder.Name -cne $correctlyCasedPackageName)) {
            Write-Information "Correcting casing of package folder from '$($packageFolder.Name)' to '$correctlyCasedPackageName'."
            [string] $temporaryPackageFolderName = "x" + $packageFolder.Name
            Write-Verbose "Moving package folder from '$($packageFolder.Name)' to '$temporaryPackageFolderName'."
            Move-Item -Path $packageFolder.Name -Destination $temporaryPackageFolderName -Force -ErrorAction Stop | Out-Null
            Write-Verbose "Moving package folder from '$temporaryPackageFolderName' to '$correctlyCasedPackageName'."
            Move-Item -Path $temporaryPackageFolderName -Destination $correctlyCasedPackageName -Force -ErrorAction Stop | Out-Null

            if ($gitRepoRootFullPath) {
                # Again, but with git this time.
                [string] $packageFolderGitPath = $packageFolder.FullName -ireplace [regex]::Escape($gitRepoRootFullPath), ""
                [string] $temporaryPackageFolderGitPath = $packageFolderGitPath -ireplace ([regex]::Escape($packageFolder.Name) + "$"), $temporaryPackageFolderName
                [string] $correctlyCasedPackageNameGitPath = $packageFolderGitPath -ireplace ([regex]::Escape($packageFolder.Name) + "$"), $correctlyCasedPackageName
                Write-Verbose "Git-moving package folder from '$packageFolderGitPath' to '$temporaryPackageFolderGitPath'."
                git mv $packageFolderGitPath $temporaryPackageFolderGitPath 2>&1 | Out-Null
                Write-Verbose "Git-moving package folder from '$temporaryPackageFolderGitPath' to '$correctlyCasedPackageNameGitPath'."
                git mv $temporaryPackageFolderGitPath $correctlyCasedPackageNameGitPath 2>&1 | Out-Null
            }

            $packageFolder = [System.IO.DirectoryInfo]::new("${PSScriptRoot}${ds}${correctlyCasedPackageName}")
        }

        # Move the package folder to the correct location, if needed.
        [System.IO.DirectoryInfo] $packageVersionFolder = $null
        if ($packageFolder -and $packageFolder.Exists) {
            $packageVersionFolder = Get-ChildItem -Path $packageFolder -Directory | Where-Object { $_.Name -ieq $packageVersion } | Select-Object -First 1
        } elseif ($packageFolder) {
            $packageVersionFolder = [System.IO.DirectoryInfo]::new("${packageFolder}${ds}${packageVersion}")
        } else {
            Write-Error "Could neither find nor create the base package folder for '$packageName'."
        }
        if (-not $packageVersionFolder -or (-not $packageVersionFolder.Exists)) {
            $packageVersionFolder = [System.IO.DirectoryInfo]::new("${packageFolder}${ds}${packageVersion}")
            Write-Information "Moving package version folder from the repositoryPath ('$trashPath') folder to the PowerShell module folder ('$packageFolder')."
            Move-Item -Path $trashPackageFolder.FullName -Destination $packageVersionFolder.FullName -Force
        }

        # Cleanup.
        Write-Verbose "Deleting the metadata files that NuGet leaves for us."
        foreach ($packageVersionVariantFolder in Get-ChildItem -Path $packageFolder.FullName -Directory) {
            Get-ChildItem -Path $packageVersionVariantFolder.FullName -Filter "*.nupkg" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionVariantFolder.FullName -Filter "*.nupkg.sha512" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionVariantFolder.FullName -Filter "*.nuspec" -File | Remove-Item -Force | Out-Null
            Get-ChildItem -Path $packageVersionVariantFolder.FullName -Filter ".nupkg.metadata" -File | Remove-Item -Force | Out-Null
        }

        # Add package folder to Git.
        if ($gitRepoRootFullPath) {
            [string] $packageFolderGitPath = $packageFolder.FullName -ireplace [regex]::Escape($gitRepoRootFullPath), ""
            Write-Verbose "Git-adding package folder '$packageFolderGitPath'."
            git add $packageFolderGitPath 2>&1 | Out-Null
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
