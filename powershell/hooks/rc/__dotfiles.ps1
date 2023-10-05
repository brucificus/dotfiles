#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Import-Module poshy-misc-funcs

if (-not (Test-SessionInteractivity)) {
    return
}

Set-Alias -Name dfu -Value Update-Dotfiles

if (Test-Path ~/.dotfiles_local -ErrorAction SilentlyContinue) {
    function Update-LocalDotfiles {
        [CmdletBinding()]
        param(
        )
        Update-Dotfiles @PSBoundParameters
        Update-Dotfiles -Path ~/.dotfiles_local @PSBoundParameters
    }

    Set-Alias -Name ldfu -Value Update-LocalDotfiles
}
