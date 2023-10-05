#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command docker)) {
    append_profile_suggestions "# TODO: 🐳 Install 'docker'. See: https://docs.docker.com/engine/installation/"
    return
}

phook_enqueue_module "poshy-wrap-docker"
