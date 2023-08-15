#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command vboxmanage) {
    # Intentionally left blank.
} elseif ((Test-Command packer) -or (Test-Command vagrant)) {
    append_profile_suggestions "# TODO: 📦 Install VirtualBox. See: https://www.virtualbox.org/wiki/Downloads."
}
