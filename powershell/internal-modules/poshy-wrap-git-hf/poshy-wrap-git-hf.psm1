#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command git-hf)) {
    return
}

function Invoke-GitHubflow {
    & $git_bin hf @args
}
Set-Alias -Name ghf -Value Invoke-GitHubflow

function Invoke-GitHubflowFeature {
    & $git_bin hf feature @args
}
Set-Alias -Name ghff -Value Invoke-GitHubflowFeature

function Invoke-GitHubflowRelease {
    & $git_bin hf release @args
}
Set-Alias -Name ghfr -Value Invoke-GitHubflowRelease

function Invoke-GitHubflowHotfix {
    & $git_bin hf hotfix @args
}
Set-Alias -Name ghfh -Value Invoke-GitHubflowHotfix

function Invoke-GitHubflowSupport {
    & $git_bin hf support @args
}
Set-Alias -Name ghfs -Value Invoke-GitHubflowSupport

function Invoke-GitHubflowUpdate {
    & $git_bin hf update @args
}
Set-Alias -Name ghfu -Value Invoke-GitHubflowUpdate


Export-ModuleMember -Function * -Alias *
