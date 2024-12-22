#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Disables npm proxy settings.
.COMPONENT
    Proxy
#>
function npm-disable-proxy {
	if (Test-Command npm) {
		npm config delete proxy
		npm config delete https-proxy
		npm config delete noproxy
		Write-Output "Disabled npm proxy settings"
    }
}
