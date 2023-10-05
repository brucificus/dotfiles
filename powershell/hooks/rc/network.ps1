#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# https://www.powershellgallery.com/packages/posh-sshell
phook_push_module "posh-sshell"

if (Test-Command ssh-agent) {
    # TODO: Port ssh-agent management functionality.
}

if (Test-Command nmap) {
    phook_enqueue_module "poshy-wrap-nmap"
}

phook_enqueue_module "poshy-net"
