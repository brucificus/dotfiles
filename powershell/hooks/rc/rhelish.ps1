#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command yum) {
    phook_enqueue_module "poshy-wrap-yum"
}

if (Test-Command dnf) {
    phook_enqueue_module "poshy-wrap-dnf"
}
