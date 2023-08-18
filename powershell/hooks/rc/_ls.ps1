#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

Remove-Alias -Name sl -Force
phook_enqueue_module "poshy-wrap-ls"
