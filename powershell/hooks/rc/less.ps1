#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if ($Env:CLICOLOR -eq 0) {
    return
}

Set-Alias -Name ccat -Value ccat.ps1
Set-Alias -Name cless -Value cless.ps1
