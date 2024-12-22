#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Shows SSH config proxy settings (from ~/.ssh/config).
.COMPONENT
    Proxy
#>
function ssh-show-proxy {
    if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
		Write-Output ""
		Write-Output "SSH Config Enabled in ~/.ssh/config"
		Write-Output "==================================="
        [string] $sshhost = $null
        Get-Content "${HOME}/.ssh/config" | ForEach-Object {
            if ($_ -match '^Host\s+(\S+)') {
                $sshhost = $matches[1]
            }
            elseif ($_ -match '^ProxyCommand\s+(.+)') {
                $proxyCommand = $matches[1]
                [PSCustomObject]@{
                    Host = $sshhost
                    ProxyCommand = $proxyCommand
                }
            }
        } | Format-Table -AutoSize

		Write-Output ""
		Write-Output "SSH Config Disabled in ~/.ssh/config"
		Write-Output "===================================="
        $sshhost = $null
		Get-Content "${HOME}/.ssh/config" | ForEach-Object {
            if ($_ -match '^Host\s+(\S+)') {
                $sshhost = $matches[1]
            }
            elseif ($_ -match '^#\s*ProxyCommand\s+(.+)') {
                $proxyCommand = $_ -replace '^#\s*ProxyCommand\s+'
                [PSCustomObject]@{
                    Host = $sshhost
                    ProxyCommand = $proxyCommand
                }
            }
        } | Format-Table -AutoSize
    }
}
