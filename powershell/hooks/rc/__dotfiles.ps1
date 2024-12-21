#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Import-Module poshy-misc-funcs

if (-not (Test-SessionInteractivity)) {
    return
}

Set-Alias -Name dfu -Value Update-Dotfiles

$Env:DOTFILES_LOCAL = (Get-Content Env:\DOTFILES_LOCAL -ErrorAction SilentlyContinue) ?? "~/.dotfiles_local"

if (Test-Path $Env:DOTFILES_LOCAL -ErrorAction SilentlyContinue) {
    <#
    .SYNOPSIS
        Updates the `dotfiles_local` repo and re-runs its installer, after first doing the same for the `dotfiles` repo.
    #>
    function Update-LocalDotfiles {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory=$false, ValueFromRemainingArguments = $true)]
            [object[]] $RepoInstallerArguments = @()
        )
        Update-Dotfiles -RepoInstallerArguments:$RepoInstallerArguments
        Update-Dotfiles -Path $Env:DOTFILES_LOCAL -RepoInstallerArguments:$RepoInstallerArguments
    }
    Set-Alias -Name ldfu -Value Update-LocalDotfiles
} else {
    Remove-Item -Path Env:\DOTFILES_LOCAL -ErrorAction SilentlyContinue
}
