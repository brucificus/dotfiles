#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if ((-not (Test-Command knife)) -or (-not (Test-Command chef)) -or (-not (Test-Command chef-client))) {
    append_profile_suggestions "# TODO: 🧑‍🍳 Install 'chef'. See: https://docs.chef.io/install_omnibus."
}

# if (Test-Command knife) {
# }

# if (Test-Command kitchen) {
# }
