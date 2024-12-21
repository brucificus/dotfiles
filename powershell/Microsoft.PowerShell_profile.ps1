#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$Env:DOTFILES = (Get-Content Env:\DOTFILES -ErrorAction SilentlyContinue) ?? "~/.dotfiles"
$OldLocation = Get-Location
Set-Location -LiteralPath "${Env:DOTFILES}/powershell"

$Env:PROFILE_STAGE = "pwsh➡️mspwsh-hosted"
$Global:phook_caller="pwsh"
$Global:phook_mode="mspwsh-hosted"

try {
    . "./init.ps1"
}
catch {
    $Env:PROFILE_STAGE = "pwsh@mspwsh-hosted❌"
    Write-Host "[pwsh|mspwsh-hosted] Profile hook failed, raised error '$($_.Exception.GetType())'. (Microsoft.PowerShell_profile.ps1)"
    throw
}
finally {
    Set-Location -LiteralPath $OldLocation
    Remove-Variable OldLocation
}
$Env:PROFILE_STAGE = "pwsh@mspwsh-hosted✅"
return
