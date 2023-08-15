#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command docker-compose)) {
    if (Test-Command docker) {
        append_profile_suggestions "# TODO: 💡 Add 'docker-compose' to your PATH."
    }
    return
}

phook_enqueue_module "poshy-wrap-docker-compose"
