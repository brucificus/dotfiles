#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command pyenv) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

function Invoke-Pyenv {
    pyenv @args
}
Set-Alias -Name pyenv -Value Invoke-Pyenv


Export-ModuleMember -Function * -Alias *
