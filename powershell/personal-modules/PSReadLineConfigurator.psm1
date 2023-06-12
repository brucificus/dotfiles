Import-Module -Name PSReadLine

[bool] $PSReadLineSupportsOptionPredictionSource = ($null -ne $(Get-PSReadLineOption).PredictionSource)

if ($PSReadLineSupportsOptionPredictionSource) {

    Set-PSReadLineOption -PredictionSource History

    [bool] $PSReadLineSupportsOptionPredictionViewStyle = ($null -ne $(Get-PSReadLineOption).PredictionViewStyle)

    if ($PSReadLineSupportsOptionPredictionViewStyle) {
        Set-PSReadLineOption -PredictionViewStyle InlineView
    }
}
