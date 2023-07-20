#!/usr/bin/env pwsh

Param(
    [switch] $SkipWslCheck = $null,
    [switch] $SkipUpdate = $null
)

if (($IsWSL -or $Env:WSL_DISTRO_NAME) -and (-not $SkipWslCheck)) {
    throw "WSL detected. Run from Windows for most compatibility, or re-run with '-SkipWslCheck'."
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
    throw "Unable to decide installation modality because unable to detect current platform."
}
