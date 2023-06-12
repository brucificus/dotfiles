$ErrorActionPreference = "Continue"

[string] $sep = [System.IO.Path]::PathSeparator
$Env:PSModulePath = "$PSScriptRoot/modules$($sep)$($Env:PSModulePath)"

. $PSScriptRoot/Initialize-PSReadLine.ps1

Import-Module -Name graphical
Import-Module -Name posh-sshell
Import-Module -Name posh-git
Import-Module -Name terminal-icons

. $PSScriptRoot/aliases.ps1

Set-PoshPromptPortably -themePath "$PSScriptRoot/../theme.omp.yaml"
