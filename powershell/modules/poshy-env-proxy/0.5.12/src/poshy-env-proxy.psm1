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
Export-ModuleMember -Function disable-proxy

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
Export-ModuleMember -Function enable-proxy


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
Export-ModuleMember -Function show-proxy


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
Export-ModuleMember -Function proxy-help

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
Export-ModuleMember -Function pwshrc-show-proxy

<#
.SYNOPSIS
    Shows the npm proxy settings.
.COMPONENT
    Proxy
#>
function npm-show-proxy {
	if (Test-Command npm) {
		Write-Output ""
		Write-Output "npm"
		Write-Output "==="
		Write-Output "npm HTTP  proxy: $(npm config get proxy)"
		Write-Output "npm HTTPS proxy: $(npm config get https-proxy)"
		Write-Output "npm proxy exceptions: $(npm config get noproxy)"
    }
}
Export-ModuleMember -Function npm-show-proxy

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
Export-ModuleMember -Function npm-disable-proxy

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
Export-ModuleMember -Function npm-enable-proxy

<#
.SYNOPSIS
    Shows global Git proxy setting.
.COMPONENT
    Proxy
#>
function git-global-show-proxy {
	if (Test-Command git) {
		Write-Output ""
		Write-Output "Git (Global Settings)"
		Write-Output "====================="
		Write-Output "Git (Global) HTTP  proxy: $(git config --global --get http.proxy)"
		Write-Output "Git (Global) HTTPS proxy: $(git config --global --get https.proxy)"
    }
}
Export-ModuleMember -Function git-global-show-proxy

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
Export-ModuleMember -Function git-global-disable-proxy

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
Export-ModuleMember -Function git-global-enable-proxy

<#
.SYNOPSIS
    Shows current Git project proxy settings.
.COMPONENT
    Proxy
#>
function git-show-proxy {
	if (Test-Command git) {
		Write-Output "Git Project Proxy Settings"
		Write-Output "====================="
		Write-Output "Git HTTP  proxy: $(git config --get http.proxy)"
		Write-Output "Git HTTPS proxy: $(git config --get https.proxy)"
    }
}
Export-ModuleMember -Function git-show-proxy

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
Export-ModuleMember -Function git-disable-proxy

<#
.SYNOPSIS
    Enables current Git project proxy settings.
.COMPONENT
    Proxy
#>
function git-enable-proxy {
    param(
        [string] $http_proxy = $Env:PWSHRC_HTTP_PROXY,
        [string] $https_proxy = $Env:PWSHRC_HTTPS_PROXY
    )
	if (Test-Command git) {
		git-disable-proxy

		git config --add http.proxy $http_proxy
		git config --add https.proxy $https_proxy
		Write-Output "Enabled Git project proxy settings"
    }
}
Export-ModuleMember -Function git-enable-proxy

<#
.SYNOPSIS
    Shows SSH config proxy settings (from ~/.ssh/config).
.COMPONENT
    Proxy
#>
function ssh-show-proxy {
    if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
		Write-Output ""
		Write-Output "SSH Config Enabled in ~/.ssh/config"
		Write-Output "==================================="
        [string] $sshhost = $null
        Get-Content "${HOME}/.ssh/config" | ForEach-Object {
            if ($_ -match '^Host\s+(\S+)') {
                $sshhost = $matches[1]
            }
            elseif ($_ -match '^ProxyCommand\s+(.+)') {
                $proxyCommand = $matches[1]
                [PSCustomObject]@{
                    Host = $sshhost
                    ProxyCommand = $proxyCommand
                }
            }
        } | Format-Table -AutoSize

		Write-Output ""
		Write-Output "SSH Config Disabled in ~/.ssh/config"
		Write-Output "===================================="
        $sshhost = $null
		Get-Content "${HOME}/.ssh/config" | ForEach-Object {
            if ($_ -match '^Host\s+(\S+)') {
                $sshhost = $matches[1]
            }
            elseif ($_ -match '^#\s*ProxyCommand\s+(.+)') {
                $proxyCommand = $_ -replace '^#\s*ProxyCommand\s+'
                [PSCustomObject]@{
                    Host = $sshhost
                    ProxyCommand = $proxyCommand
                }
            }
        } | Format-Table -AutoSize
    }
}
Export-ModuleMember -Function ssh-show-proxy

<#
.SYNOPSIS
    Disables SSH config proxy settings.
.COMPONENT
    Proxy
#>
function ssh-disable-proxy {
    if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
        [string[]] $sshConfigLines = Get-Content -Path ~/.ssh/config
        $sshConfigLines = $sshConfigLines | ForEach-Object {
            if ($_ -match "^.*ProxyCommand.*") {
                "# $_"
            } else {
                $_
            }
        }
        $sshConfigLines | Set-Content -Path ~/.ssh/config
		Write-Output "Disabled SSH config proxy settings"
    }
}
Export-ModuleMember -Function ssh-disable-proxy

<#
.SYNOPSIS
    Enables SSH config proxy settings.
.COMPONENT
    Proxy
#>
function ssh-enable-proxy {
	if (Test-Path ~/.ssh/config -ErrorAction SilentlyContinue) {
        [string[]] $sshConfigLines = Get-Content -Path ~/.ssh/config
        $sshConfigLines = $sshConfigLines | ForEach-Object {
            if ($_ -match "^#.*ProxyCommand.*") {
                $_ -replace "^#(\s)?", ""
            } else {
                $_
            }
        }
        $sshConfigLines | Set-Content -Path ~/.ssh/config
		Write-Output "Enabled SSH config proxy settings"
    }
}
Export-ModuleMember -Function ssh-enable-proxy
