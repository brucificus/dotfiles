#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-env-var"; RequiredVersion = "0.6.0" }


<#
.SYNOPSIS
    Disables proxy settings for Bash, npm, Git, and SSH.
.COMPONENT
    Proxy
#>
function disable-proxy {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [switch] $SkipEnvironmentVariables,

        [Parameter(Mandatory = $false, Position = 1)]
        [switch] $SkipNpm,

        [Parameter(Mandatory = $false, Position = 2)]
        [switch] $SkipGitGlobal,

        [Parameter(Mandatory = $false, Position = 3)]
        [switch] $SkipSsh
    )
    if (-not $SkipEnvironmentVariables) {
        Remove-EnvVar -Process -Name http_proxy
        Remove-EnvVar -Process -Name https_proxy
        Remove-EnvVar -Process -Name HTTP_PROXY
        Remove-EnvVar -Process -Name HTTPS_PROXY
        Remove-EnvVar -Process -Name ALL_PROXY
        Remove-EnvVar -Process -Name no_proxy
        Remove-EnvVar -Process -Name NO_PROXY
        Write-Output "Disabled proxy environment variables"
    }

    if (-not $SkipNpm) {
        npm-disable-proxy
    }
	if (-not $SkipGitGlobal) {
        git-global-disable-proxy
    }
    if (-not $SkipSsh) {
	    ssh-disable-proxy
    }
}
