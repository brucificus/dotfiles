#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command hub) {
    # Intentionally left blank.

    # See `git.ps1` for the `hub` alias.
} elseif (Test-Command git) {
    append_profile_suggestions "# TODO: 🐙 Install 'hub'. See: https://github.com/mislav/hub#installation."
}
