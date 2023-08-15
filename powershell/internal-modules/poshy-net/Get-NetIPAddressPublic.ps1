#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Get-NetIPAddressPublic {
    # note: could also try "http://checkip.dyndns.com/" or "http://checkip.dyndns.org/"
    Invoke-RestMethod "http://myip.dnsomatic.com/"
}
