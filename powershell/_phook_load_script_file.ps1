#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$SCRIPT = $args[0]
$SCRIPT_0 = (Resolve-Path $SCRIPT -Relative -ErrorAction SilentlyContinue) ?? $SCRIPT
$SCRIPT_ARGS = ($args.Length -gt 1) ? $args[1..($args.Length-1)] : @()
try {
    $SCRIPT = Resolve-Path $SCRIPT
} catch {
    Write-Warning "[${Global:phook_caller}|${Global:phook_mode}] Pathing failed for '$SCRIPT_0', raised error '$($_.Exception.GetType())'."
    throw
}

$SCRIPT_DIR = Split-Path -Path $SCRIPT -Parent

Set-Location $SCRIPT_DIR
try  {
    Write-Information "[$Global:phook_caller|$Global:phook_mode] Sourcing component: $SCRIPT_0"
    if (assert_sourced $SCRIPT @SCRIPT_ARGS) {
        Write-Debug "[$Global:phook_caller|$Global:phook_mode] Component already sourced, skipping."
        return
    }

    if ($SCRIPT -like "*.ps1") {
        . $SCRIPT @SCRIPT_ARGS
    } elseif ($SCRIPT -like "*.psm1") {
        Import-Module -Name $SCRIPT -DisableNameChecking -Global -ArgumentList $SCRIPT_ARGS
    } elseif ($SCRIPT -like "*.psd1") {
        Import-Module -Name $SCRIPT -DisableNameChecking -Global -ArgumentList $SCRIPT_ARGS
    } else {
        throw "Unknown file type '$($SCRIPT)'."
        return
    }
} catch {
    Write-Debug "[${Global:phook_caller}|${Global:phook_mode}] Sourcing component failed, raised error '$($_.Exception.GetType())'."
    throw
}
finally {
    Set-Location $PSScriptRoot
    Remove-Variable -Name SCRIPT
    Remove-Variable -Name SCRIPT_0
    Remove-Variable -Name SCRIPT_DIR
}
