Import-Module -Name PSReadLine

[bool] $PSReadLineSupportsOptionPredictionSource = ($null -ne $(Get-PSReadLineOption).PredictionSource)

if ($PSReadLineSupportsOptionPredictionSource) {
    [bool] $AzureCliAvailable = [bool](Get-Command az -ErrorAction SilentlyContinue)
    [bool] $MachineIsUsedForAzureDevelopment = $AzureCliAvailable

    if ($MachineIsUsedForAzureDevelopment) {
        Import-Module Az.Tools.Predictor
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    } else {
        Set-PSReadLineOption -PredictionSource History
    }

    [bool] $PSReadLineSupportsOptionPredictionViewStyle = ($null -ne $(Get-PSReadLineOption).PredictionViewStyle)

    if ($PSReadLineSupportsOptionPredictionViewStyle) {
        Set-PSReadLineOption -PredictionViewStyle InlineView
    }
}
