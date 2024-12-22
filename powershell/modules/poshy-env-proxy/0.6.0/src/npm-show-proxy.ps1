#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Shows the npm proxy settings.
.COMPONENT
    Proxy
#>
function npm-show-proxy {
	if (Test-Command npm) {
		Write-Output ""
		Write-Output "npm"
		Write-Output "==="
		Write-Output "npm HTTP  proxy: $(npm config get proxy)"
		Write-Output "npm HTTPS proxy: $(npm config get https-proxy)"
		Write-Output "npm proxy exceptions: $(npm config get noproxy)"
    }
}
