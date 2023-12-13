#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Defines a very basic prompt that emulates the default prompt of the Bash shell on Debian.

if ($IsWindows) {
    return
}

if (-not (Test-SessionInteractivity)) {
    return
}

function prompt {
    param(
    )

    # set variable identifying the chroot you work in (used in the prompt below)
    if (Test-f /etc/debian_chroot) {
        $debian_chroot = Get-Content /etc/debian_chroot
    } else {
        $debian_chroot = ""
    }

    # set a fancy prompt
    if ($Env:TERM -like "xterm-color" -or $Env:TERM -like "*-256color") {
        $color_prompt = $true
    }

    if ((Test-Command tput) -and (tput setaf 1 | Out-Null))
    {
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        $color_prompt=$true
    } else {
        $color_prompt=$false
    }

    $debian_chroot_for_prompt = $debian_chroot ? "(${debian_chroot}) " : ""
    $ps = [System.IO.Path]::PathSeparator
    $hn=(hostname)
    if ($color_prompt -and ($Env:CLICOLOR -ne 0)) {
        return "${debian_chroot_for_prompt}`e[01;32m${env:USERNAME}@${hn}`e[00m${ps}`e[01;34m$(Get-Location)`e[00m$ "
    } else {
        return "${debian_chroot_for_prompt}${env:USERNAME}@${hn}${ps}$(Get-Location)$ "
    }
    Remove-Variable -Name ps
}
