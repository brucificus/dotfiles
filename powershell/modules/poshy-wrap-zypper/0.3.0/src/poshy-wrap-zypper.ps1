#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


#Main commands
function Invoke-Zypper {
    sudo zypper @args
}
# A common alias for _Zoxide_ users is `z`, so we don't panic if it's already taken.
Set-Alias -Name z -Value Invoke-Zypper -ErrorAction SilentlyContinue

function Invoke-ZypperHelp {
    zypper -h @args
}
Set-Alias -Name zh -Value Invoke-ZypperHelp

function Invoke-ZypperHelpSearch {
    zypper -h se @args
}
Set-Alias -Name zhse -Value Invoke-ZypperHelpSearch

function Invoke-ZypperLicenses {
    zypper licenses @args
}
Set-Alias -Name zlicenses -Value Invoke-ZypperLicenses

function Invoke-ZypperListProcessesLockingPackages {
    sudo zypper ps @args
}
Set-Alias -Name zps -Value Invoke-ZypperListProcessesLockingPackages

function Invoke-ZypperShell {
    sudo zypper shell @args
}
Set-Alias -Name zshell -Value Invoke-ZypperShell

function Invoke-ZypperSourceDownload {
    sudo zypper source-download @args
}
Set-Alias -Name zsource-download -Value Invoke-ZypperSourceDownload

function Invoke-ZypperTargetOS {
    zypper tos @args
}
Set-Alias -Name ztos -Value Invoke-ZypperTargetOS

function Invoke-ZypperVersionCompare {
    zypper vcmp @args
}
Set-Alias -Name zvcmp -Value Invoke-ZypperVersionCompare


#Packages commands
function Invoke-ZypperIn {
    sudo zypper in @args
}
Set-Alias -Name zin -Value Invoke-ZypperIn

function Invoke-ZypperInstallNewRecommends {
    sudo zypper inr @args
}
Set-Alias -Name zinr -Value Invoke-ZypperInstallNewRecommends

function Invoke-ZypperRemove {
    sudo zypper rm @args
}
Set-Alias -Name zrm -Value Invoke-ZypperRemove

function Invoke-ZypperSourceInstall {
    sudo zypper si @args
}
Set-Alias -Name zsi -Value Invoke-ZypperSourceInstall

function Invoke-ZypperVerify {
    sudo zypper ve @args
}
Set-Alias -Name zve -Value Invoke-ZypperVerify


#Updates commands
function Invoke-ZypperDistUpgrade {
    sudo zypper dup @args
}
Set-Alias -Name zdup -Value Invoke-ZypperDistUpgrade

function Invoke-ZypperListPackages {
    zypper lp @args
}
Set-Alias -Name zlp -Value Invoke-ZypperListPackages

function Invoke-ZypperListUpdates {
    zypper lu @args
}
Set-Alias -Name zlu -Value Invoke-ZypperListUpdates

function Invoke-ZypperPatchCheck {
    sudo zypper pchk @args
}
Set-Alias -Name zpchk -Value Invoke-ZypperPatchCheck

function Invoke-ZypperUpdate {
    sudo zypper up @args
}
Set-Alias -Name zup -Value Invoke-ZypperUpdate

function Invoke-ZypperPatch {
    sudo zypper patch @args
}
Set-Alias -Name zpatch -Value Invoke-ZypperPatch


#Request commands
function Invoke-ZypperIf {
    zypper --no-refresh if @args
}
Set-Alias -Name zif -Value Invoke-ZypperIf

function Invoke-ZypperPackages {
    zypper --no-refresh pa @args
}
Set-Alias -Name zpa -Value Invoke-ZypperPackages

function Invoke-ZypperPatchInfo {
    zypper --no-refresh patch-info @args
}
Set-Alias -Name zpatch-info -Value Invoke-ZypperPatchInfo

function Invoke-ZypperPatternInfo {
    zypper --no-refresh pattern-info @args
}
Set-Alias -Name zpattern-info -Value Invoke-ZypperPatternInfo

function Invoke-ZypperProductInfo {
    zypper --no-refresh product-info @args
}
Set-Alias -Name zproduct-info -Value Invoke-ZypperProductInfo

function Invoke-ZypperPatches {
    zypper --no-refresh pch @args
}
Set-Alias -Name zpch -Value Invoke-ZypperPatches

function Invoke-ZypperProducts {
    zypper --no-refresh pd @args
}
Set-Alias -Name zpd -Value Invoke-ZypperProducts

function Invoke-ZypperPatterns {
    zypper --no-refresh pt @args
}
Set-Alias -Name zpt -Value Invoke-ZypperPatterns

function Invoke-ZypperSearch {
    zypper --no-refresh se @args
}
Set-Alias -Name zse -Value Invoke-ZypperSearch

function Invoke-ZypperWhatProvides {
    zypper --no-refresh wp @args
}
Set-Alias -Name zwp -Value Invoke-ZypperWhatProvides


#Repositories commands
function Invoke-ZypperAdRepo {
    sudo zypper ar @args
}
Set-Alias -Name zar -Value Invoke-ZypperAdRepo

function Invoke-ZypperClean {
    sudo zypper clean @args
}
Set-Alias -Name zcl -Value Invoke-ZypperClean

function Invoke-ZypperListRepos {
    zypper lr @args
}
Set-Alias -Name zlr -Value Invoke-ZypperListRepos

function Invoke-ZypperModifyRepo {
    sudo zypper mr @args
}
Set-Alias -Name zmr -Value Invoke-ZypperModifyRepo

function Invoke-ZypperRenameRepo {
    sudo zypper nr @args
}
Set-Alias -Name znr -Value Invoke-ZypperRenameRepo

function Invoke-ZypperRefresh {
    sudo zypper ref @args
}
Set-Alias -Name zref -Value Invoke-ZypperRefresh

function Invoke-ZypperRemoveRepo {
    sudo zypper rr @args
}
Set-Alias -Name zrr -Value Invoke-ZypperRemoveRepo


#Services commands
function Invoke-ZypperAddService {
    sudo zypper as @args
}
Set-Alias -Name zas -Value Invoke-ZypperAddService

function Invoke-ZypperModifyService {
    sudo zypper ms @args
}
Set-Alias -Name zms -Value Invoke-ZypperModifyService

function Invoke-ZypperRefreshServices {
    sudo zypper refs @args
}
Set-Alias -Name zrefs -Value Invoke-ZypperRefreshServices

function Invoke-ZypperRemoveService {
    sudo zypper rs @args
}
Set-Alias -Name zrs -Value Invoke-ZypperRemoveService

function Invoke-ZypperListServices {
    zypper ls @args
}
Set-Alias -Name zls -Value Invoke-ZypperListServices


#Package Locks Management commands
function Invoke-ZypperAddLock {
    sudo zypper al @args
}
Set-Alias -Name zal -Value Invoke-ZypperAddLock

function Invoke-ZypperCleanLocks {
    sudo zypper cl @args
}
Set-Alias -Name zcl -Value Invoke-ZypperCleanLocks

function Invoke-ZypperListLocks {
    zypper ll @args
}
Set-Alias -Name zll -Value Invoke-ZypperListLocks

function Invoke-ZypperRemoveLock {
    sudo zypper rl @args
}
Set-Alias -Name zrl -Value Invoke-ZypperRemoveLock


Export-ModuleMember -Function * -Alias *
