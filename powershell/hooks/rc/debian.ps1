#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command apt-get)) {
    return
}

phook_enqueue_module "poshy-wrap-apt"
