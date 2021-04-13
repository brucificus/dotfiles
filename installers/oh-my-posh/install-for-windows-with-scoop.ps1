#!/usr/bin/env pwsh
#Requires -RunAsAdministrator

Param(
)

if (-not $IsWindows) {
    Write-Error "Windows is required."
    return
}

if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    Write-Error "Scoop is required for installing 'oh-my-posh' on Windows."
    return
}

if (-not (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) {
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
} else {
    scoop update oh-my-posh
}

