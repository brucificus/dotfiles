#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

# This is a helper layered on top of the `argcomplete` support for PowerShell.
# For more information about PowerShell support in `argcomplete`, see: https://github.com/kislyuk/argcomplete/tree/develop/contrib#powershell-support

$argcompleteRegisterCommand = Get-Command register-python-argcomplete -ErrorAction SilentlyContinue

if ($argcompleteRegisterCommand) {
    [string[]] $argcompletePrograms = Get-Content -Path "$PSScriptRoot/../../../config/argcomplete/compat_programs.txt"
    foreach ($program in $argcompletePrograms) {
        if (Get-Command $program -ErrorAction SilentlyContinue) {
            Register-ArgcompleteArgumentCompleter $program
        }
    }
}
