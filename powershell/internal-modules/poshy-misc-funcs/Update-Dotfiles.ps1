#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Update dotfiles.
function Update-Dotfiles {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory=$false, Position = 0, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $Path = '~/.dotfiles'
    )
    if (-not (Test-LinkCapability)) {
        if ($IsWindows) {
            Write-Error "This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session, or enable Developer Mode in Windows Settings."
        } else {
            Write-Error "This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session."
        }
        return
    }
    if (-not (Test-ReparsePoint ~/.dotfiles -Force -ErrorAction SilentlyContinue)) {
        if (-not $PSCmdlet.ShouldContinue("'~/.dotfiles' update might not work correctly, because it is not a symlink.", "Continue?")) {
            return
        }
    }
    [System.IO.DirectoryInfo] $dotfiles_wc = Expand-ReparsePoint ~/.dotfiles -Force
    Push-Location $dotfiles_wc -Force | Out-Null
    try {
        git pull --ff-only
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        ./install.ps1 -q
    } finally {
        Pop-Location | Out-Null
    }
}
