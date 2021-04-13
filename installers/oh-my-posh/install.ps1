#!/usr/bin/env pwsh

Param(
    [switch] $SkipWslCheck = $null,
    [switch] $SkipUpdate = $null
)

if ($Env:WSL_DISTRO_NAME -and (-not $SkipWslCheck)) {
    Write-Error "WSL detected. Run from Windows for most compatibility, or re-run with '-SkipWslCheck'."
    return
}

if ( `
    ((Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) `
    -or (Get-Command "oh-my-posh-wsl" -ErrorAction SilentlyContinue)) `
    -and -$SkipUpdate) {
    Write-Warning "'oh-my-posh' is already installed and update is being skipped."
    return
}

if ($IsWindows) {
    ~/.dotfiles/installers/oh-my-posh/install-for-windows-with-scoop.ps1
} elseif ($IsLinux) {
    ~/.dotfiles/installers/oh-my-posh/install-for-nix-with-wget.ps1
} else {
    Write-Error "Unable to decide installation modality because unable to detect current platform."
    return
}
