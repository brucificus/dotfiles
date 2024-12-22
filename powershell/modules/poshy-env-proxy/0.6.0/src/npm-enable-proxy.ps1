#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Enables npm proxy settings.
.COMPONENT
    Proxy
#>
function npm-enable-proxy {
    param(
        [string] $http_proxy = $Env:PWSHRC_HTTP_PROXY,
        [string] $https_proxy = $Env:PWSHRC_HTTPS_PROXY,
        [string] $no_proxy = $Env:PWSHRC_NO_PROXY
    )
	if (Test-Command npm) {
		npm config set proxy $http_proxy
        if ($LASTEXITCODE -ne 0) {
            exit
        }
		npm config set https-proxy $https_proxy
        if ($LASTEXITCODE -ne 0) {
            exit
        }
		npm config set noproxy $no_proxy
        if ($LASTEXITCODE -ne 0) {
            exit
        }
		Write-Output "Enabled npm proxy settings"
    }
}
