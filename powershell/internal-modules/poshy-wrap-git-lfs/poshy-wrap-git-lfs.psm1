#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command git-lfs)) {
    return
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
    local b="$(git_current_branch)"
    & $git_bin lfs push origin "$b" --all
}


Export-ModuleMember -Function * -Alias *
