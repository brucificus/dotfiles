Import-Module -Name PSReadLine

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
}
