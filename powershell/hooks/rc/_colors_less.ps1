#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Colorize 'less' for man pages for better readability.
if ($Env:CLICOLOR -eq 0) {
    return
}

if (-not (Test-Command "less")) {
    return
}

phook_enqueue_module poshy-ecks

Set-Alias -Name ccat -Value ccat.ps1
Set-Alias -Name cless -Value cless.ps1

if ((-not (Test-Command pygmentize)) -and (-not (Test-Command chroma))) {
    append_profile_suggestions "# TODO: 🌈 Install 'Pygments' or 'Chroma'. See: https://pygments.org/download/ or https://github.com/alecthomas/chroma/releases/."
}
