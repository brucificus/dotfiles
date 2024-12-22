#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


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
