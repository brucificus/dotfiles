#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


function Invoke-PylintReportsDisabled {
    pylint --reports=n @args
}
Set-Alias -Name pylint-quick -Value Invoke-PylintReportsDisabled


Export-ModuleMember -Function * -Alias *
