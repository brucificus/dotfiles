#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Provides an overview of the pwshrc proxy configuration.
.COMPONENT
    Proxy
#>
function proxy-help {
    "
    Bash-it provides support for enabling/disabling proxy settings for various shell tools.

    The following backends are currently supported (in addition to the shell's environment variables): Git, SVN, npm, ssh

    Bash-it uses the following variables to set the shell's proxy settings when you call 'enable-proxy'.
    * PWSHRC_HTTP_PROXY and PWSHRC_HTTPS_PROXY: Define the proxy URL to be used, e.g. 'http://localhost:1234'
    * PWSHRC_NO_PROXY: A comma-separated list of proxy exclusions, e.g. '127.0.0.1,localhost'

    Run 'glossary proxy' to show the available proxy functions with a short description.
    "

        pwshrc-show-proxy
    }
