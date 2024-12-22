#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
#Requires -Modules @{ ModuleName = "poshy-env-var"; RequiredVersion = "0.6.0" }


<#
.SYNOPSIS
    Shows the proxy settings for Bash, Git, npm and SSH.
.COMPONENT
    Proxy
#>
function show-proxy {
    Get-EnvVar -Process -NameLike '*proxy*'

	pwshrc-show-proxy
	npm-show-proxy
	git-global-show-proxy
	ssh-show-proxy
}
