#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$SCRIPT = $args[0]
$SCRIPT_0 = (Resolve-Path $SCRIPT -Relative -ErrorAction SilentlyContinue) ?? $SCRIPT
$SCRIPT_ARGS = ($args.Length -gt 1) ? $args[1..($args.Length-1)] : @()
if ($SCRIPT -like "*.psm1" -or $SCRIPT -like "*.psd1") {
    try {
        $SCRIPT = Resolve-Path $SCRIPT
    } catch {
        Write-Warning "[${Global:phook_caller}|${Global:phook_mode}] Pathing failed for '$SCRIPT_0', raised error '$($_.Exception.GetType())'."
        throw
    }

    $SCRIPT_DIR = Split-Path -Path $SCRIPT -Parent

    Set-Location $SCRIPT_DIR
}
try  {
    Write-Information "[$Global:phook_caller|$Global:phook_mode] Importing module: $SCRIPT_0"
    if ($SCRIPT -like "*.psm1" -or $SCRIPT -like "*.psd1") {
        if (assert_sourced $SCRIPT @SCRIPT_ARGS) {
            Write-Debug "[$Global:phook_caller|$Global:phook_mode] Module already imported, skipping."
            return
        }
    }

    Import-Module -Name $SCRIPT -DisableNameChecking -Global -ArgumentList $SCRIPT_ARGS
} catch {
    Write-Debug "[${Global:phook_caller}|${Global:phook_mode}] Importing module failed, raised error '$($_.Exception.GetType())'."
    throw
}
finally {
    Set-Location $PSScriptRoot
    Remove-Variable -Name SCRIPT -ErrorAction SilentlyContinue
    Remove-Variable -Name SCRIPT_0 -ErrorAction SilentlyContinue
    Remove-Variable -Name SCRIPT_DIR -ErrorAction SilentlyContinue
}
