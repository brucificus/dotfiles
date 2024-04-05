#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command ha) {
    Invoke-Expression (ha completion powershell)
}
