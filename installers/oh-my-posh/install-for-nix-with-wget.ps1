#!/usr/bin/env pwsh
#Requires -RunAsAdministrator

Param(
)

if (-not $IsLinux) {
    Write-Error "*nix is required."
    return
}

if (-not (Get-Command "wget" -ErrorAction SilentlyContinue)) {
    Write-Error "Wget is required for installing 'oh-my-posh' on *nix."
    return
}

if ((id -u) -ne 0) {
    Write-Error "Root is required for installing 'oh-my-posh' on *nix."
    return
}

[string] $ohmyposhPlatform

if ($Env:HOSTTYPE -ceq "x86_64") {
    $ohmyposhPlatform = "amd64"
} elseif ($Env:HOSTTYPE -like "*arm*") {
    $ohmyposhPlatform = "arm"
} else {
    Write-Error "Unable to select 'oh-my-posh' package platform for current platform."
    return
}

[string] $ohmyposhUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-" + $ohmyposhPlatform

wget $ohmyposhUrl -O /usr/local/bin/oh-my-posh

chmod +x /usr/local/bin/oh-my-posh
