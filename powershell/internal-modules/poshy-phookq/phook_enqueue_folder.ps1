#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_enqueue_folder() {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $path,

        [Parameter(Mandatory=$false, Position=1)]
        [switch] $Optional,

        [Parameter(Mandatory=$false, Position=2)]
        [switch] $AsFunctions
    )

    if (-not (Test-Path -Path $path -PathType Container -ErrorAction SilentlyContinue)) {
        if (-not $Optional) {
            throw "The path '$path' is not a folder, or it does not exist."
        }
        return
    }

    [System.IO.FileSystemInfo[]] $children_files = (
        Get-ChildItem -Path $path `
        | Where-Object { $_.Name -notlike ".*" } `
        | Where-Object { ($_.Name -like "*.ps1") -or ($_.Name -like "*.psm1") -or ($_.Name -like "*.psd1") -or ($_.PSIsContainer) }
        | Sort-Object -Property Name -Unique
    )
    [string[]] $children = $children_files | Select-Object -ExpandProperty Name

    $folder_name = (Get-Item -Path $path).Name

    # Check if the folder has a module defined.
    [string] $folderModule = $null
    if ($children -contains "${folder_name}.psd1") {
        $folderModule = "${folder_name}.psd1"
    } elseif ($children -contains "${folder_name}.psm1") {
        $folderModule = "${folder_name}.psm1"
    }

    if ($folderModule) {
        # If the folder has a module defined, enqueue it.
        # Unless it's already loaded.
        [string] $folderModulePath = Join-Path $path $folderModule
        $folderModulePath = Resolve-Path -Path $folderModulePath
        if (Get-Module | Where-Object { $_.Path -eq $folderModulePath }) {
            return
        }
        phook_enqueue_module $folderModulePath
    } else {
        # If the folder does NOT have a module defined, enqueue its files and folders.
        foreach ($child in $children) {
            $child_path = Join-Path $path $child
            if (Test-Path -Path $child_path -PathType Container) {
                phook_enqueue_folder $child_path -AsFunctions:$AsFunctions
            } else {
                if ($AsFunctions) {
                    [string] $expectedFunctionName = $child.Replace(".ps1", "")
                    if (Get-Command $expectedFunctionName -ErrorAction SilentlyContinue) {
                        continue
                    }
                }
                phook_enqueue_file $child_path
            }
        }
    }
}
