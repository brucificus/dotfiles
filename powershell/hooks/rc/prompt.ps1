#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Set-Alias -Name load_ohmyposh_theme -Value Set-PoshPromptPortably

load_ohmyposh_theme -themePath "$PSScriptRoot/../../../theme.omp.yaml"
