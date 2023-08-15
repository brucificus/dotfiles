#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$Env:PROFILE_STAGE = "pwsh➡️mspwsh-hosted"
$Global:phook_caller="pwsh"
$Global:phook_mode="mspwsh-hosted"
Set-Location "~/.dotfiles/powershell"
try {
    . "./init.ps1"
}
catch {
    $Env:PROFILE_STAGE = "pwsh@mspwsh-hosted❌"
    Write-Host "[pwsh|mspwsh-hosted] Profile hook failed, raised error '$($_.Exception.GetType())'. (Microsoft.PowerShell_profile.ps1)"
    throw
}
finally {
    Set-Location "~"
}
$Env:PROFILE_STAGE = "pwsh@mspwsh-hosted✅"
return
