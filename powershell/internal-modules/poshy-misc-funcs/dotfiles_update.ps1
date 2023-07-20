#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Update dotfiles
function dotfiles_update {
    Push-Location (Get-Item ~/.dotfiles).Target | Out-Null
    try {
        git pull --ff-only
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        ./install.ps1 -q
    } finally {
        Pop-Location | Out-Null
    }
}
