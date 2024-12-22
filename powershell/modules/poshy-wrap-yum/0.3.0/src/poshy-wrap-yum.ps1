#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


# search package
function Invoke-YumSearch {
    yum search @args
}
Set-Alias -Name ys -Value Invoke-YumSearch

# show package info
function Invoke-YumInfo {
    yum info @args
}
Set-Alias -Name yp -Value Invoke-YumInfo

# list packages
function Invoke-YumList {
    yum list @args
}
Set-Alias -Name yl -Value Invoke-YumList

# list package groups
function InvokeYumGrouplist {
    yum grouplist @args
}
Set-Alias -Name ygl -Value InvokeYumGrouplist

# print all installed packages
function Invoke-YumListInstalled {
    yum list installed @args
}
Set-Alias -Name yli -Value Invoke-YumListInstalled

# rebuilds the yum package list
function Invoke-YumMakecache {
    yum makecache @args
}
Set-Alias -Name ymc -Value Invoke-YumMakecache

# upgrade packages
function Invoke-YumUpdate {
    sudo yum update @args
}
Set-Alias -Name yu -Value Invoke-YumUpdate

# install package
function Invoke-YumInstall {
    sudo yum install @args
}
Set-Alias -Name yi -Value Invoke-YumInstall

# install package group
function Invoke-YumGroupinstall {
    sudo yum groupinstall @args
}
Set-Alias -Name ygi -Value Invoke-YumGroupinstall

# remove package
function Invoke-YumRemove {
    sudo yum remove @args
}
Set-Alias -Name yr -Value Invoke-YumRemove

# remove pagage group
function Invoke-YumGroupremove {
    sudo yum groupremove @args
}
Set-Alias -Name ygr -Value Invoke-YumGroupremove

# remove package and leaves
function Invoke-YumRemoveLeaves {
    sudo yum remove --remove-leaves @args
}
Set-Alias -Name yrl -Value Invoke-YumRemoveLeaves

# clean cache
function Invoke-YumCleanAll {
    sudo yum clean all @args
}
Set-Alias -Name yc -Value Invoke-YumCleanAll


Export-ModuleMember -Function * -Alias *
