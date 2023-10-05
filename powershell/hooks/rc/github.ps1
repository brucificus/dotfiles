#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command git) {
    Set-Alias -Name fpr -Value gh_fetch_pr
}

if (Test-Command gh) {
    Set-Alias -Name fpr -Value gh_fetch_pr
} elseif (Test-Command git) {
    append_profile_suggestions "# TODO: 🐱 Install 'gh'. See: https://github.com/cli/cli#installation."
}
