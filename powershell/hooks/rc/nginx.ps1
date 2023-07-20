#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not $Env:NGINX_PATH) {
    if (Test-Path /opt/nginx -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name NGINX_PATH -Value /opt/nginx
    }
}
if (Test-Path ${Env:NGINX_PATH}/sbin -ErrorAction SilentlyContinue) {
    Add-EnvPathItem -Process -Value ${Env:NGINX_PATH}/sbin
}
if (-not (Test-Command nginx)) {
    append_profile_suggestions "# TODO: 🌐 Install 'nginx'."
    return
} elseif (-not $Env:NGINX_PATH) {
    append_profile_suggestions "# TODO: 🌐 Set 'NGINX_PATH' to the nginx install path."
    return
}
if ($IsWindows) {
    return
}

phook_enqueue_module "poshy-wrap-nginx"
