#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command systemctl) {
    phook_enqueue_module "poshy-wrap-systemctl"
}
