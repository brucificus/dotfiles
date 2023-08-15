#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Get-Variable -Name phook_loader_q -Scope Global -ErrorAction SilentlyContinue)) {
    $Global:phook_loader_q = [System.Collections.ArrayList]::new()
} else {
    $Global:phook_loader_q ??= [System.Collections.ArrayList]::new()
}


foreach ($item in Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" -File) {
    . $item.FullName
}

Export-ModuleMember -Function *
assert_sourced $PSCommandPath | Out-Null
