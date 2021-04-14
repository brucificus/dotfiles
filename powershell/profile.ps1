$ErrorActionPreference = "Continue"

[string] $sep = [System.IO.Path]::PathSeparator

$Env:PSModulePath = "~/.dotfiles/powershell/modules$($sep)$($Env:PSModulePath)"

Import-Module -Name oh-my-posh
Import-Module -Name posh-git
Import-Module -Name terminal-icons

. "~/.dotfiles/powershell/aliases.ps1"

Set-PoshPrompt -Theme powerlevel10k_classic

~\bin\Import-OptionallyExtantScriptOrModule.ps1 -path "~\.config\powershell\profile_local"
