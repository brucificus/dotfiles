#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

function Get-ChildItemVerbosely {
    Get-ChildItem @args | Format-Table -AutoSize
}
Set-Alias -Name vdir -Value Get-ChildItemVerbosely -Option AllScope -Force

# https://www.powershellgallery.com/packages/Terminal-Icons
if (Get-Module Terminal-Icons -ListAvailable -ErrorAction SilentlyContinue) {
    phook_push_module "Terminal-Icons"
} else {
    append_profile_suggestions "# TODO: ``Install-Module Terminal-Icons``."
}
