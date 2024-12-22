#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Enables global Git proxy settings.
.COMPONENT
    Proxy
#>
function git-global-enable-proxy {
    param(
        [string] $http_proxy = $Env:PWSHRC_HTTP_PROXY,
        [string] $https_proxy = $Env:PWSHRC_HTTPS_PROXY
    )
	if (Test-Command git) {
		git-global-disable-proxy

		git config --global --add http.proxy $http_proxy
		git config --global --add https.proxy $https_proxy
		Write-Output "Enabled global Git proxy settings"
    }
}
