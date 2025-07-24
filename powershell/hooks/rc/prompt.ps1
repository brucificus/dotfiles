#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if (-not (Test-Command "oh-my-posh")) {
    # Use Kali Linux default prompt since we don't have oh-my-posh.
    function prompt {
        # TODO: Fix not reading any changes that kali-tweaks made to these variables.
        #       ('kali-tweaks' overwrites them in `~/.config/powershell/Microsoft.PowerShell_profile.ps1`.)
        $PROMPT_ALTERNATIVE='twoline'
        $NEWLINE_BEFORE_PROMPT='yes'

        $esc = [char]27
        $bell = [char]7
        $bold = "$esc[1m"
        $reset = "$esc[0m"
        If ($NEWLINE_BEFORE_PROMPT -eq 'yes') { Write-Host }
        If ($PROMPT_ALTERNATIVE -eq 'twoline') {
            Write-Host "┌──(" -NoNewLine -ForegroundColor Blue
            Write-Host "${bold}$([environment]::username)㉿$([system.environment]::MachineName)${reset}" -NoNewLine -ForegroundColor Magenta
            Write-Host ")-[" -NoNewLine -ForegroundColor Blue
            Write-Host "${bold}$(Get-Location)${reset}" -NoNewLine -ForegroundColor White
            Write-Host "]" -ForegroundColor Blue
            Write-Host "└─" -NoNewLine -ForegroundColor Blue
            Write-Host "${bold}PS>${reset}" -NoNewLine -ForegroundColor Blue
        } Else {
            Write-Host "${bold}PS " -NoNewLine -ForegroundColor Blue
            Write-Host "$([environment]::username)@$([system.environment]::MachineName) " -NoNewLine -ForegroundColor Magenta
            Write-Host "$(Get-Location)>${reset}" -NoNewLine -ForegroundColor Blue
        }
        # Terminal title
        Write-Host "${esc}]0;PS> $([environment]::username)@$([system.environment]::MachineName): $(Get-Location)${bell}" -NoNewLine
        return " "
    }
} else {
    Set-Alias -Name load_ohmyposh_theme -Value Set-PoshPromptPortably

    Set-PoshPromptPortably -themePath "$PSScriptRoot/../../../theme.omp.yaml"
}
