#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command curl) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

function Invoke-CurlFollowingRedirects {
    curl -L @args
}
Set-Alias -Name cl -Value Invoke-CurlFollowingRedirects

function Invoke-CurlFollowingRedirectsDownloadAsNamed {
    curl -L -O @args
}
Set-Alias -Name clo -Value Invoke-CurlFollowingRedirectsDownloadAsNamed

function Invoke-CurlFollowingRedirectsDownloadAsNamedContinue {
    curl -L -C - -O @args
}
Set-Alias -Name cloc -Value Invoke-CurlFollowingRedirectsDownloadAsNamedContinue

function Invoke-CurlFollowingRedirectsDownloadAsNamedContinueAndRetry {
    curl -L -C - -O --retry 5 @args
}
Set-Alias -Name clocr -Value Invoke-CurlFollowingRedirectsDownloadAsNamedContinueAndRetry

function Invoke-CurlFollowingRedirectsFetchBanner {
    curl -L -I @args
}
Set-Alias -Name clb -Value Invoke-CurlFollowingRedirectsFetchBanner

function Invoke-CurlOnlyForGetResponseHeaders {
    curl -D - -so /dev/null @args
}
Set-Alias -Name clhead -Value Invoke-CurlOnlyForGetResponseHeaders


Export-ModuleMember -Function * -Alias *
