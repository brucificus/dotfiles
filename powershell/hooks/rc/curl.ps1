#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
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
