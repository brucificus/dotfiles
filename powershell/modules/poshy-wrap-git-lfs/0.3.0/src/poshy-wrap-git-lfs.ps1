#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


[string] $git_bin = $null
if (Test-Command hub) {
    $git_bin = "hub"
} elseif (Test-Command git) {
    $git_bin = "git"
}

function Invoke-GitLfsInstall {
    & $git_bin lfs install @args
}
Set-Alias -Name glfsi -Value Invoke-GitLfsInstall

function Add-GitLfsTrackedFiles() {
    & $git_bin lfs track @args
}
Set-Alias -Name glfst -Value Add-GitLfsTrackedFiles

function Get-GitLfsTrackedFiles() {
    & $git_bin lfs ls-files @args
}
Set-Alias -Name glfsls -Value Get-GitLfsTrackedFiles

function Invoke-GitLfsMigrateImport() {
    & $git_bin lfs migrate import --include= @args
}
Set-Alias -Name glfsmi -Value Invoke-GitLfsMigrateImport

function gplfs() {
    [string] $b = "$(git_current_branch)"
    & $git_bin lfs push origin "$b" --all
}


Export-ModuleMember -Function * -Alias *
