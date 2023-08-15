#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command dotnet)) {
    append_profile_suggestions "# TODO: 🔨 Install 'dotnet'. See: https://learn.microsoft.com/en-us/dotnet/core/install/linux."
    return
}

phook_enqueue_module "poshy-wrap-dotnet"
