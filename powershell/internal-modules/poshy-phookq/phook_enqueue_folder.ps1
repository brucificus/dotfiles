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

    [System.IO.FileSystemInfo[]] $children = @()
    $children += @(Get-ChildItem -Path $path -Filter "*.psd1" -File -Force)
    $children += @(Get-ChildItem -Path $path -Filter "*.psm1" -File -Force)
    $children = @($children | Where-Object { $_.Name -notlike ".*" } | Sort-Object -Property Name -Unique)

    # If the folder DOES have a module defined, use it.
    if ($children) {
        phook_enqueue_module $children[0].FullName
        return
    }

    # Since the folder does NOT have a module defined, use its files and folders.
    $children += @(Get-ChildItem -Path $path -Filter "*.ps1" -File -Force)
    $children += @(Get-ChildItem -Path $path -Directory -Force)
    $children = @($children | Where-Object { $_.Name -notlike ".*" } | Sort-Object -Property Name -Unique)

    foreach ($child in $children) {
        if ($child -is [System.IO.DirectoryInfo]) {
            phook_enqueue_folder $child.FullName -AsFunctions:$AsFunctions
        } else {
            phook_enqueue_file $child.FullName
        }
    }
}
