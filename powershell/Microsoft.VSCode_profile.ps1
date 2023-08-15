#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$Env:PROFILE_STAGE = "pwsh➡️vscode-hosted"
$Global:phook_caller="pwsh"
$Global:phook_mode="vscode-hosted"
Set-Location "~/.dotfiles/powershell"
try {
    . "./init.ps1"
}
catch {
    $Env:PROFILE_STAGE = "pwsh@vscode-hosted❌"
    Write-Host "[pwsh|vscode-hosted] Profile hook failed, raised error '$($_.Exception.GetType())'. (Microsoft.VSCode_profile.ps1)"
    throw
}
finally {
    Set-Location "~"
}
$Env:PROFILE_STAGE = "pwsh@vscode-hosted✅"
return
