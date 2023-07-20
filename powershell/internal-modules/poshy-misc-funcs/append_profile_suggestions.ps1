#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function append_profile_suggestions {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $suggestion
    )

    if (-not (Test-Path Env:\PROFILE_SUGGESTIONS -ErrorAction SilentlyContinue)) {
        Set-EnvVar -Process -Name PROFILE_SUGGESTIONS -Value $suggestion
    } else {
        Set-EnvVar -Process -Name PROFILE_SUGGESTIONS -Value ($Env:PROFILE_SUGGESTIONS + [Environment]::NewLine + $suggestion)
    }
}
