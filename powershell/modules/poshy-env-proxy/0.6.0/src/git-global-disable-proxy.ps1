#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Disables global Git proxy settings.
.COMPONENT
    Proxy
#>
function git-global-disable-proxy {
	if (Test-Command git) {
		git config --global --unset-all http.proxy
		git config --global --unset-all https.proxy
		Write-Output "Disabled global Git proxy settings"
    }
}
