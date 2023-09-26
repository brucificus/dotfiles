#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command pylint) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

function Invoke-PylintReportsDisabled {
    pylint --reports=n @args
}
Set-Alias -Name pylint-quick -Value Invoke-PylintReportsDisabled


Export-ModuleMember -Function * -Alias *
