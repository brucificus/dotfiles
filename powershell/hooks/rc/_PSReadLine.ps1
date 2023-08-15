#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


phook_push_module "PSReadLine"

# https://www.powershellgallery.com/packages/PowerType
if (Get-Module PowerType -ListAvailable -ErrorAction SilentlyContinue) {
    phook_push_module "PowerType"
} else {
    append_profile_suggestions "# TODO: ``Install-Module PowerType``."
}
