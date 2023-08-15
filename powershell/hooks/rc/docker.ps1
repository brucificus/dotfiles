#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command docker)) {
    append_profile_suggestions "# TODO: 🐳 Install 'docker'. See: https://docs.docker.com/engine/installation/"
    return
}

phook_enqueue_module "poshy-wrap-docker"
