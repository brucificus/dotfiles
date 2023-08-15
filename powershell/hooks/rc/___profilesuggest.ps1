#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Path Env:\PROFILE_SUGGESTIONS -ErrorAction SilentlyContinue)) {
    Set-EnvVar -Process -Name PROFILE_SUGGESTIONS -Value ''
}
