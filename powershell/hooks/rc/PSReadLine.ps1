#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
#Requires -Modules @{ModuleName="PSReadLine";ModuleVersion="2.2.6"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

[bool] $PSReadLineSupportsOptionPredictionSource = ($null -ne $(Get-PSReadLineOption).PredictionSource)

if ($PSReadLineSupportsOptionPredictionSource) {

    if ([Microsoft.PowerShell.PredictionSource]::HistoryAndPlugin) {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    } else {
        Set-PSReadLineOption -PredictionSource History
    }

    if (Get-Command Enable-PowerType -ErrorAction SilentlyContinue) {
        Enable-PowerType
    }

    [bool] $PSReadLineSupportsOptionPredictionViewStyle = ($null -ne $(Get-PSReadLineOption).PredictionViewStyle)

    if ($PSReadLineSupportsOptionPredictionViewStyle) {
        Set-PSReadLineOption -PredictionViewStyle InlineView
    }

    Remove-Variable -Name PSReadLineSupportsOptionPredictionViewStyle
}
Remove-Variable -Name PSReadLineSupportsOptionPredictionSource
