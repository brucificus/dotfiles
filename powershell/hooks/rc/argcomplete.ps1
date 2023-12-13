#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

try {
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
} finally {
    Remove-Variable -Name argcompletePrograms -ErrorAction SilentlyContinue
    Remove-Variable -Name argcompleteRegisterCommand -ErrorAction SilentlyContinue
    Remove-Variable -Name program -ErrorAction SilentlyContinue
}
