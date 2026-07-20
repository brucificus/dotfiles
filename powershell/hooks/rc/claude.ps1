#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if (-not (Test-Command claude)) {
    append_profile_suggestions "# TODO: 🤖 Install Claude Code."
    return
}

# https://code.claude.com/docs/en/env-vars

# TODO: Implement Bash equivalent.

if ($IsWindows) {
    $Env:CLAUDE_CODE_USE_POWERSHELL_TOOL = "1"
}

if (Test-Path ~/.claude.frugally -ErrorAction SilentlyContinue) {
    $Env:CLAUDE_CODE_DISABLE_1M_CONTEXT = "1"
    $Env:CLAUDE_CODE_AUTO_COMPACT_WINDOW = "175000"
    $Env:CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = "80"
    $Env:CLAUDE_EFFORT = "medium"
    $Env:CLAUDE_CODE_EFFORT_LEVEL = "medium"
}
