#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command zypper) {
    phook_enqueue_module "poshy-wrap-zypper"
}
