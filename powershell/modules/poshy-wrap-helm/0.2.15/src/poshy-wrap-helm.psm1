#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command helm) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

function Invoke-Helm {
    helm @args
}
Set-Alias -Name h -Value Invoke-Helm

function Invoke-HelmInstall {
    helm install @args
}
Set-Alias -Name hin -Value Invoke-HelmInstall

function Invoke-HelmSearch {
    helm search @args
}
Set-Alias -Name hse -Value Invoke-HelmSearch

function Invoke-HelmUpgrade {
    helm upgrade @args
}
Set-Alias -Name hup -Value Invoke-HelmUpgrade


Export-ModuleMember -Function * -Alias *
