#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Set-PoshPromptPortably([string] $themePath) {
    if ($IsLinux -and (Get-Command "oh-my-posh-wsl" -ErrorAction SilentlyContinue)) {
        Invoke-Expression (oh-my-posh-wsl --init --shell pwsh --config $themePath)
    }
    elseif (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) {
        Invoke-Expression (oh-my-posh --init --shell pwsh --config $themePath)
    } else {
        Set-PoshPrompt -Theme $themePath
    }
}
