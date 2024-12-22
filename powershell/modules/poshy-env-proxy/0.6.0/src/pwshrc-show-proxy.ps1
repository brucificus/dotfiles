#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-env-var"; RequiredVersion = "0.6.0" }


<#
.SYNOPSIS
    Shows the pwshrc proxy settings.
.COMPONENT
    Proxy
#>
function pwshrc-show-proxy {
	Write-Output ""
	Write-Output "Pwshrc Environment Variables"
	Write-Output "============================="
	Write-Output "(These variables will be used to set the proxy when you call 'enable-proxy')"
	Write-Output ""
    Get-EnvVar -Process -NameMatch 'PWSHRC.*PROXY'
}
