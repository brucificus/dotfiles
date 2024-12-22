#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


function Invoke-Pyenv {
    pyenv @args
}
Set-Alias -Name pyenv -Value Invoke-Pyenv


Export-ModuleMember -Function * -Alias *
