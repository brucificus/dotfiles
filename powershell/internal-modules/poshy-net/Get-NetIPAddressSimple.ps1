#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


<#
.SYNOPSIS
    Get all IP addresses for this host.
#>
function Get-NetIPAddressSimple {
    Get-NetIPAddress @args | Select-Object -ExpandProperty IPAddress
}
