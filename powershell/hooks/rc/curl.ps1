#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if (Test-Command curl) {
    phook_enqueue_module "poshy-wrap-curl"
} else {
    append_profile_suggestions "# TODO: 🌐 Install 'curl'."
}