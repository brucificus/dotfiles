#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command gem)) {
    return
}

# Run sudo gem on the system ruby, not the active ruby
function Invoke-GemSystem {
    sudo gem @args
}
Set-Alias -Name sgem -Value Invoke-GemSystem

# Gem Command Shorthands
function Invoke-GemInstall {
    gem install @args
}
Set-Alias -Name gein -Value Invoke-GemInstall

function Invoke-GemUninstall {
    gem uninstall @args
}
Set-Alias -Name geun -Value Invoke-GemUninstall

function Invoke-GemList {
    gem list @args
}
Set-Alias -Name geli -Value Invoke-GemList

function Invoke-GemInfo {
    gem info @args
}
Set-Alias -Name gei -Value Invoke-GemInfo

function Invoke-GemInfoAll {
    gem info --all @args
}
Set-Alias -Name geiall -Value Invoke-GemInfoAll

function Invoke-GemCertAdd {
    gem cert --add @args
}
Set-Alias -Name geca -Value Invoke-GemCertAdd

function Invoke-GemCertRemove {
    gem cert --remove @args
}
Set-Alias -Name gecr -Value Invoke-GemCertRemove

function Invoke-GemCertBuild {
    gem cert --build @args
}
Set-Alias -Name gecb -Value Invoke-GemCertBuild

function Invoke-GemCleanupNo {
    gem cleanup -n @args
}
Set-Alias -Name geclup -Value Invoke-GemCleanupNo

function Invoke-GemGenerateIndex {
    gem generate_index @args
}
Set-Alias -Name gegi -Value Invoke-GemGenerateIndex

function Invoke-GemHelp {
    gem help @args
}
Set-Alias -Name geh -Value Invoke-GemHelp

function Invoke-GemLock {
    gem lock @args
}
Set-Alias -Name gel -Value Invoke-GemLock

function Invoke-GemOpen {
    gem open @args
}
Set-Alias -Name geo -Value Invoke-GemOpen

function Invoke-GemOpenEditor {
    gem open -e @args
}
Set-Alias -Name geoe -Value Invoke-GemOpenEditor

<#
.SYNOPSIS
    Removes installed gem.
.COMPONENT
    Ruby
#>
function Invoke-GemRemoveByPattern {
    param(
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "NameMatch")]
        [ValidateNotNullOrEmpty()]
        [string] $NameMatch,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "NameLike")]
        [ValidateNotNullOrEmpty()]
        [string] $NameLike
    )
    [string[]] $matchingGems = @()
    if ($NameMatch) {
        $matchingGems = gem list | Where-Object {
            $_ -match $NameMatch
        }
    } elseif ($NameLike) {
        $matchingGems = gem list | Where-Object {
            $_ -like $NameLike
        }
    } else {
        throw "Invalid parameter set."
    }

    sudo gem uninstall @matchingGems
}
Set-Alias -Name remove_gem -Value Invoke-GemRemoveByPattern


Export-ModuleMember -Function * -Alias *
