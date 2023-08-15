#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Remove-Alias -Name sl -Force
phook_enqueue_module "poshy-wrap-ls"
