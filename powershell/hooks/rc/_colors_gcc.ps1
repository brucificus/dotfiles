#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Colorized GCC warnings and errors.

if ($Env:CLICOLOR -eq 0) {
    return
}

Set-EnvVar -Process -Name GCC_COLORS -Value 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
