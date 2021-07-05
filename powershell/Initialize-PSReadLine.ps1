Import-Module -Name PSReadLine

[bool] $AzureCliAvailable = [bool](Get-Command az -ErrorAction SilentlyContinue)
[bool] $MachineIsUsedForAzureDevelopment = $AzureCliAvailable

if ($MachineIsUsedForAzureDevelopment) {
    Import-Module Az.Tools.Predictor
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
} else {
    Set-PSReadLineOption -PredictionSource History
}

Set-PSReadLineOption -PredictionViewStyle InlineView
