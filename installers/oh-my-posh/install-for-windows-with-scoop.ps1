#!/usr/bin/env pwsh
#Requires -RunAsAdministrator

Param(
)

if (-not $IsWindows) {
    throw "Windows is required."
}

if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    throw "Scoop is required for installing 'oh-my-posh' on Windows."
}

if (-not (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue)) {
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
} else {
    scoop update oh-my-posh
}

