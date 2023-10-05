#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
#Requires -Modules @{ModuleName="PSReadLine";ModuleVersion="2.2.6"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

Set-Alias -Name pbcopy -Value Set-Clipboard
Set-Alias -Name pbpaste -Value Get-Clipboard
Set-Alias -Name xcpy -Value Set-Clipboard
Set-Alias -Name xpst -Value Get-Clipboard

function Open-Clipboard {
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true)]
        [object[]] $InputObject = $null
    )
    if ($InputObject) {
        $InputObject | Set-Clipboard
    } else {
        Get-Clipboard
    }
}
Set-Alias -Name clip -Value Open-Clipboard

function Copy-PSReadLineBuffer {
    [string] $buffer = $null
    [int] $cursor = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursor)
    $buffer | Set-Clipboard
}

Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock { Copy-PSReadLineBuffer }
