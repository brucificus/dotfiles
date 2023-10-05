#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Path Env:\PROFILE_SUGGESTIONS -ErrorAction SilentlyContinue)) {
    Set-EnvVar -Process -Name PROFILE_SUGGESTIONS -Value ''
}
