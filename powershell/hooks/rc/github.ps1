#!/usr/bin/env pwsh
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
