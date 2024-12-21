#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$Env:DOTFILES = (Get-Content Env:\DOTFILES -ErrorAction SilentlyContinue) ?? "~/.dotfiles"
$OldLocation = Get-Location
Set-Location -LiteralPath "${Env:DOTFILES}/powershell"

$Env:PROFILE_STAGE = "pwsh➡️rc"
$Global:phook_caller="pwsh"
$Global:phook_mode="rc"

try {
    . "./init.ps1"
}
catch {
    $Env:PROFILE_STAGE = "pwsh@rc❌"
    Write-Host "[pwsh|rc] Profile hook failed, raised error '$($_.Exception.GetType())'. (profile.ps1)"
    throw
}
finally {
    Set-Location -LiteralPath $OldLocation
    Remove-Variable OldLocation
}
$Env:PROFILE_STAGE = "pwsh@rc✅"
return
