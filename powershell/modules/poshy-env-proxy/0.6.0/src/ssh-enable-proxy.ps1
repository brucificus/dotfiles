#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Enables SSH config proxy settings.
.COMPONENT
    Proxy
#>
function ssh-enable-proxy {
	if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
        [string[]] $sshConfigLines = Get-Content -Path ~/.ssh/config
        $sshConfigLines = $sshConfigLines | ForEach-Object {
            if ($_ -match "^#.*ProxyCommand.*") {
                $_ -replace "^#(\s)?", ""
            } else {
                $_
            }
        }
        $sshConfigLines | Set-Content -Path ~/.ssh/config
		Write-Output "Enabled SSH config proxy settings"
    }
}
