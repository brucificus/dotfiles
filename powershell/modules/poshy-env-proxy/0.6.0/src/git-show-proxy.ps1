#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Shows current Git project proxy settings.
.COMPONENT
    Proxy
#>
function git-show-proxy {
	if (Test-Command git) {
		Write-Output "Git Project Proxy Settings"
		Write-Output "====================="
		Write-Output "Git HTTP  proxy: $(git config --get http.proxy)"
		Write-Output "Git HTTPS proxy: $(git config --get https.proxy)"
    }
}
