$ErrorActionPreference = "Continue"

$Env:PSModulePath = "~\.dotfiles\powershell\modules;$($Env:PSModulePath)"

Import-Module -Name oh-my-posh
Import-Module -Name posh-git
Import-Module -Name terminal-icons

Set-PoshPrompt -Theme powerlevel10k_classic

~\bin\Import-OptionallyExtantScriptOrModule.ps1 -path "~\.config\powershell\profile_local"
