#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


<#
.SYNOPSIS
    Disables current Git project proxy settings.
.COMPONENT
    Proxy
#>
function git-disable-proxy {
	if (Test-Command git) {
		git config --unset-all http.proxy
		git config --unset-all https.proxy
		Write-Output "Disabled Git project proxy settings"
    }
}
