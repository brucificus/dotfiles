#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command yum) {
    phook_enqueue_module "poshy-wrap-yum"
}

if (Test-Command dnf) {
    phook_enqueue_module "poshy-wrap-dnf"
}
