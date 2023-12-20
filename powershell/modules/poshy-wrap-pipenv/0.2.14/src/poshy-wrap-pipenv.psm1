#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command pipenv) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

function Invoke-PipenvCheck {
    pipenv check @args
}
Set-Alias -Name pch -Value Invoke-PipenvCheck

function Invoke-PipenvClean {
    pipenv clean @args
}
Set-Alias -Name pcl -Value Invoke-PipenvClean

function Invoke-PipenvGraph {
    pipenv graph @args
}
Set-Alias -Name pgr -Value Invoke-PipenvGraph

function Invoke-PipenvInstall {
    pipenv install @args
}
Set-Alias -Name pi -Value Invoke-PipenvInstall

function Invoke-PipenvInstallDev {
    pipenv install --dev @args
}
Set-Alias -Name pidev -Value Invoke-PipenvInstallDev

function Invoke-PipenvLock {
    pipenv lock @args
}
Set-Alias -Name pl -Value Invoke-PipenvLock

function Invoke-PipenvOpen {
    pipenv open @args
}
Set-Alias -Name po -Value Invoke-PipenvOpen

function Invoke-PipenvRun {
    pipenv run @args
}
Set-Alias -Name prun -Value Invoke-PipenvRun

function Invoke-PipenvShell {
    pipenv shell @args
}
Set-Alias -Name psh -Value Invoke-PipenvShell

function Invoke-PipenvSync {
    pipenv sync @args
}
Set-Alias -Name psy -Value Invoke-PipenvSync

function Invoke-PipenvUninstall {
    pipenv uninstall @args
}
Set-Alias -Name pu -Value Invoke-PipenvUninstall

function Invoke-PipenvUpdate {
    pipenv update @args
}
Set-Alias -Name pupd -Value Invoke-PipenvUpdate

function Invoke-PipenvWhere {
    pipenv --where @args
}
Set-Alias -Name pwh -Value Invoke-PipenvWhere

function Invoke-PipenvVenv {
    pipenv --venv @args
}
Set-Alias -Name pvenv -Value Invoke-PipenvVenv

function Invoke-PipenvPy {
    pipenv --py @args
}
Set-Alias -Name ppy -Value Invoke-PipenvPy


Export-ModuleMember -Function * -Alias *
