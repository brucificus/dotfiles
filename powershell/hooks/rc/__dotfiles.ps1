#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Import-Module poshy-misc-funcs

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
