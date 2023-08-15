#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$Env:PROFILE_STAGE = "pwsh➡️rc"
$Global:phook_caller="pwsh"
$Global:phook_mode="rc"
Set-Location "~/.dotfiles/powershell"
try {
    . "./init.ps1"
}
catch {
    $Env:PROFILE_STAGE = "pwsh@rc❌"
    Write-Host "[pwsh|rc] Profile hook failed, raised error '$($_.Exception.GetType())'. (profile.ps1)"
    throw
}
finally {
    Set-Location "~"
}
$Env:PROFILE_STAGE = "pwsh@rc✅"
return
