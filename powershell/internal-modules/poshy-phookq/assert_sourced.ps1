#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function assert_sourced() {
    param(
        [Parameter(Mandatory = $true)]
        [string] $script
    )
    $script = Resolve-Path $script
    [string[]] $script_args = ($args.Length -gt 1) ? $args[1..($args.Length-1)] : @()

    [string] $varname = '__REQUIRED__' + ($script -replace "[^\w]", "__")
    foreach ($script_arg in $script_args) {
        $varname += '__' + ($script_arg -replace "[^\w]", "__")
    }

    if (-not (Get-Variable -Name $varname -Scope Global -ErrorAction SilentlyContinue)) {
        Set-Variable -Name $varname -Value $true -Scope Global
        return $false
    } else {
        return (Get-Variable -Name $varname -Scope Global -ValueOnly)
    }
}
