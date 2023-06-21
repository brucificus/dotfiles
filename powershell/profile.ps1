$ErrorActionPreference = "Continue"

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }


[string] $sep = [System.IO.Path]::PathSeparator
$Env:PSModulePath = "$PSScriptRoot/modules$($sep)$($Env:PSModulePath)"

Import-Module -Name graphical
Import-Module -Name posh-sshell
if (Get-Command git -ErrorAction 'SilentlyContinue') {
    Import-Module -Name posh-git
}
Import-Module -Name terminal-icons
Import-Module -Name powertype


Import-Module -Name $PSScriptRoot\personal-modules\DotfilesHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\EnvHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\PythonHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\EditorHelpers.psm1 -DisableNameChecking
if (Get-Command git -ErrorAction 'SilentlyContinue') {
    Import-Module -Name $PSScriptRoot\personal-modules\GitHelpers.psm1 -DisableNameChecking
}
Import-Module -Name $PSScriptRoot\personal-modules\NavigationHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\ProjectHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\PSReadLineConfigurator.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\ReflectionHelpers.psm1 -DisableNameChecking


function Set-PoshPromptPortably([string] $themePath) {
    if ($IsLinux -and (Get-Command "oh-my-posh-wsl" -ErrorAction SilentlyContinue)) {
        Invoke-Expression (oh-my-posh-wsl --init --shell pwsh --config $themePath)
    }
    elseif (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) {
        Invoke-Expression (oh-my-posh --init --shell pwsh --config $themePath)
    } else {
        Set-PoshPrompt -Theme $themePath
    }
}

Set-PoshPromptPortably -themePath "$PSScriptRoot/../theme.omp.yaml"
