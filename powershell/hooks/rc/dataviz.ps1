#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# https://www.powershellgallery.com/packages/Graphical
if (Get-Module Graphical -ListAvailable -ErrorAction SilentlyContinue) {
    phook_push_module "Graphical"
} else {
    append_profile_suggestions "# TODO: ``Install-Module Graphical``."
}
