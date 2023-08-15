#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command go)) {
    append_profile_suggestions "# TODO: 🐹 Install 'go'. See: https://go.dev/doc/install"
    return
}
# Test `go version` because goenv creates shim scripts that will be found in PATH
# but do not always resolve to a working install.
[string] $goversion = (go version 2> $null)
if (($LASTEXITCODE -ne 0) -or (-not $goversion)) {
    append_profile_suggestions "# TODO: 🐹 Install 'go'. See: https://go.dev/doc/install"
    return
}

Set-EnvVar -Process -Name GOROOT -Value (go env GOROOT)
Set-EnvVar -Process -Name GOPATH -Value (go env GOPATH)

# ${Env:GOPATH}/bin is the default location for binaries. Because $Env:GOPATH accepts a list of paths and each
# might be managed differently, we add each path's /bin folder to $Env:PATH using pathmunge,
# while preserving ordering.
# e.g. $Env:GOPATH=foo:bar  ->  $Env:PATH=foo/bin:bar/bin
Get-EnvVarPathItem -Process -Name GOPATH | ForEach-Object {
    Add-EnvVarPathItem -Process -Name PATH -Value $_\bin
}

phook_enqueue_module "poshy-wrap-golang"
