#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command vboxmanage) {
    # Intentionally left blank.
} elseif ((Test-Command packer) -or (Test-Command vagrant)) {
    append_profile_suggestions "# TODO: 📦 Install VirtualBox. See: https://www.virtualbox.org/wiki/Downloads."
}
