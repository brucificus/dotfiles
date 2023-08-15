#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function New-WindowsTerminalPane {
    [CmdletBinding()]
    param(
        [switch] $currentWindow
    )
    Begin {
        [string[]] $commandArguments = @("sp", "-d", ".")
        if ($currentWindow -and $currentWindow.IsPresent) {
            $commandArguments = @("-w", "0") + $commandArguments
        }
        wt @commandArguments
    }
}
