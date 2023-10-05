#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

phook_push_module "PSReadLine"

# https://www.powershellgallery.com/packages/PowerType
if (Get-Module PowerType -ListAvailable -ErrorAction SilentlyContinue) {
    phook_push_module "PowerType"
} else {
    append_profile_suggestions "# TODO: ``Install-Module PowerType``."
}
