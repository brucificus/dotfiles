#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Shows global Git proxy setting.
.COMPONENT
    Proxy
#>
function git-global-show-proxy {
	if (Test-Command git) {
		Write-Output ""
		Write-Output "Git (Global Settings)"
		Write-Output "====================="
		Write-Output "Git (Global) HTTP  proxy: $(git config --global --get http.proxy)"
		Write-Output "Git (Global) HTTPS proxy: $(git config --global --get https.proxy)"
    }
}
