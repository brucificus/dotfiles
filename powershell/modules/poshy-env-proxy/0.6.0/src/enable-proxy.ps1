#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-env-var"; RequiredVersion = "0.6.0" }


<#
.SYNOPSIS
    Enables proxy settings for Bash, npm, Git, and SSH.
.COMPONENT
    Proxy
#>
function enable-proxy {
    param(
        [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'Alt')]
        [switch] $Alt,

        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Custom')]
        [string] $http_proxy = $Alt ? $Env:PWSHRC_HTTP_PROXY_ALT : $Env:PWSHRC_HTTP_PROXY,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Custom')]
        [string] $https_proxy = $Alt ? $Env:PWSHRC_HTTPS_PROXY_ALT : $Env:PWSHRC_HTTPS_PROXY,

        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'Custom')]
        [string] $no_proxy = $Alt ? $Env:PWSHRC_NO_PROXY_ALT : $Env:PWSHRC_NO_PROXY,

        [Parameter(Mandatory = $false, Position = 3)]
        [switch] $SkipEnvironmentVariables,

        [Parameter(Mandatory = $false, Position = 4)]
        [switch] $SkipNpm,

        [Parameter(Mandatory = $false, Position = 6)]
        [switch] $SkipGitGlobal,

        [Parameter(Mandatory = $false, Position = 5)]
        [switch] $SkipSsh
    )
    if (-not $SkipEnvironmentVariables) {
        Set-EnvVar -Process -Name http_proxy -Value $http_proxy
        Set-EnvVar -Process -Name https_proxy -Value $https_proxy
        Set-EnvVar -Process -Name HTTP_PROXY -Value $http_proxy
        Set-EnvVar -Process -Name HTTPS_PROXY -Value $https_proxy
        Set-EnvVar -Process -Name ALL_PROXY -Value $http_proxy
        Set-EnvVar -Process -Name no_proxy -Value $no_proxy
        Set-EnvVar -Process -Name NO_PROXY -Value $no_proxy
        if ($Alt) {
            Write-Output "Enabled alternate proxy environment variables"
        } else {
            Write-Output "Enabled proxy environment variables"
        }
    }

    if (-not $SkipNpm) {
        npm-enable-proxy $http_proxy $https_proxy $no_proxy
    }

    if (-not $SkipGitGlobal) {
        git-global-enable-proxy $http_proxy $https_proxy
    }

    ssh-enable-proxy
}
