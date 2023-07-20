#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


for ($phook_loader_current = (phook_loader_pop); $phook_loader_current; $phook_loader_current = (phook_loader_pop)) {
    # $phook_loader_current = [PSCustomObject]@{
    #    path = "<some path>"
    #    optional = < $true || $false >
    #    kind = < "file" || "module" >
    # }
    if ($phook_loader_current.kind -eq "file") {
        if (Test-Path $phook_loader_current.path -ErrorAction SilentlyContinue) {
            if ($phook_loader_current.path -like "./funcs/*") {
                [string] $expected_func_name = $func_file.Name -replace "\.ps1$", ""
                if (-not (Test-Path -Path "function:\$expected_func_name")) {
                    assert_sourced $phook_loader_current.path | Out-Null
                    . $phook_loader_current.path
                }
            } else {
                . "$PSScriptRoot/_phook_load_script_file.ps1" $phook_loader_current.path
            }
        } elseif ($phook_loader_current.optional) {
            continue
        } else {
            throw [System.IO.FileNotFoundException]::new("File not found: " + $phook_loader_current.path)
        }
    } elseif ($phook_loader_current.kind -eq "module") {
        . "$PSScriptRoot/_phook_load_script_module.ps1" $phook_loader_current.path
    } else {
        throw "Unknown kind: $($phook_loader_current.kind)"
    }
}
