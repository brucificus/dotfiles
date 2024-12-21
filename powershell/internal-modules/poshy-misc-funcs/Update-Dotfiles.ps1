#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Updates and reinstalls the dotfiles repo.
# Optionally takes a path to the dotfiles repo as an argument, defaults to the value of $Env:DOTFILES or "~/.dotfiles".
function Update-Dotfiles {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory=$false, Position = 0, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $Path = (Get-Content Env:\DOTFILES -ErrorAction SilentlyContinue) ?? "~/.dotfiles",

        [Parameter(Mandatory=$false, ValueFromRemainingArguments = $true)]
        [object[]] $RepoInstallerArguments = @()
    )
    if (-not (Test-LinkCapability)) {
        if ($IsWindows) {
            Write-Error "Update-Dotfiles: This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session, or enable Developer Mode in Windows Settings."
        } else {
            Write-Error "Update-Dotfiles: This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session."
        }
        return
    }
    if (-not (Test-ReparsePoint $Path -Force -ErrorAction SilentlyContinue)) {
        if (-not $PSCmdlet.ShouldContinue("Update-Dotfiles: Updating '$Path' might not work correctly, because it is not a symlink.", "Continue?")) {
            return
        }
    }
    [System.IO.DirectoryInfo] $dotfiles_wc = Expand-ReparsePoint $Path -Force
    Push-Location $dotfiles_wc | Out-Null
    try {
        git pull --ff-only
        if ($LASTEXITCODE -eq 0) {
            ./install.ps1 -q @RepoInstallerArguments
        } else {
            Write-Error "Update-Dotfiles: Failed git pull repo '$Path'."
        }
    } finally {
        Pop-Location | Out-Null
    }
}
