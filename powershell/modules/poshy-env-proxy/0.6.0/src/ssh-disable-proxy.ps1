#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Disables SSH config proxy settings.
.COMPONENT
    Proxy
#>
function ssh-disable-proxy {
    if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
        [string[]] $sshConfigLines = Get-Content -Path ~/.ssh/config
        $sshConfigLines = $sshConfigLines | ForEach-Object {
            if ($_ -match "^.*ProxyCommand.*") {
                "# $_"
            } else {
                $_
            }
        }
        $sshConfigLines | Set-Content -Path ~/.ssh/config
		Write-Output "Disabled SSH config proxy settings"
    }
}
