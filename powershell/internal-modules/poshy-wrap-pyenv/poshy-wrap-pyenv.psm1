#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command pyenv)) {
    return
}

function Invoke-Pyenv {
    pyenv @args
}
Set-Alias -Name pyenv -Value Invoke-Pyenv


Export-ModuleMember -Function * -Alias *
