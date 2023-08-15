#!/usr/bin/env pwsh
#Requires -RunAsAdministrator

Param(
)

if (-not $IsLinux) {
    throw "*nix is required."
}

if (-not (Get-Command "wget" -ErrorAction SilentlyContinue)) {
    throw "Wget is required for installing 'oh-my-posh' on *nix."
}

if ((id -u) -ne 0) {
    throw "Root is required for installing 'oh-my-posh' on *nix."
}

[string] $ohmyposhPlatform

if ($Env:HOSTTYPE -ceq "x86_64") {
    $ohmyposhPlatform = "amd64"
} elseif ($Env:HOSTTYPE -like "*arm*") {
    $ohmyposhPlatform = "arm"
} else {
    throw "Unable to select 'oh-my-posh' package platform for current platform."
}

[string] $ohmyposhUrl = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-" + $ohmyposhPlatform

wget $ohmyposhUrl -O /usr/local/bin/oh-my-posh

chmod +x /usr/local/bin/oh-my-posh
