#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_push_folder() {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $path
    )

    $children = Get-ChildItem -Path $path -Filter "*.ps1" -File | Where-Object { $_.Name -notlike ".*" }
    $children += (Get-ChildItem -Path $path -Filter "*.psm1" -File | Where-Object { $_.Name -notlike ".*" })
    $children += (Get-ChildItem -Path $path -Filter "*.psd1" -File | Where-Object { $_.Name -notlike ".*" })
    $children += (Get-ChildItem -Path $path -Directory | Where-Object { $_.Name -notlike ".*" })
    $children = $children | Select-Object -ExpandProperty Name | Sort-Object -Unique

    $folder_name = (Get-Item -Path $path).Name

    # Check if the folder has a module defined.
    if ($children -contains "${folder_name}.psd1") {
        # If the folder has a module defined, push it.
        phook_push_module (Join-Path $path "${folder_name}.psd1")
    } elseif ($children -contains "${folder_name}.psm1") {
        # If the folder has a module defined, push it.
        phook_push_module (Join-Path $path "${folder_name}.psm1")
    } else {
        # If the folder does NOT have a module defined, push its files and folders.
        foreach ($child in $children) {
            $child_path = Join-Path $path $child
            if (Test-Path -Path $child_path -PathType Container) {
                phook_push_folder $child_path
            } else {
                phook_push_file $child_path
            }
        }
    }
}
