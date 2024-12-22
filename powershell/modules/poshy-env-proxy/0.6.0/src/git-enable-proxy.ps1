#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Enables current Git project proxy settings.
.COMPONENT
    Proxy
#>
function git-enable-proxy {
    param(
        [string] $http_proxy = $Env:PWSHRC_HTTP_PROXY,
        [string] $https_proxy = $Env:PWSHRC_HTTPS_PROXY
    )
	if (Test-Command git) {
		git-disable-proxy

		git config --add http.proxy $http_proxy
		git config --add https.proxy $https_proxy
		Write-Output "Enabled Git project proxy settings"
    }
}
