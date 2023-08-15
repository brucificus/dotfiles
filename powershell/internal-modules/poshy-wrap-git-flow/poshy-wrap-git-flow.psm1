#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command git-flow)) {
    return
}

function Use-GitFlowBranchDevelop {
    & $git_bin checkout (git config gitflow.branch.develop) @args
}
Set-Alias -Name gcd -Value Use-GitFlowBranchDevelop

function Use-GitFlowBranchHotfix {
    & $git_bin checkout (git config gitflow.prefix.hotfix) @args
}
Set-Alias -Name gch -Value Use-GitFlowBranchHotfix

function Use-GitFlowBranchRelease {
    & $git_bin checkout (git config gitflow.prefix.release) @args
}
Set-Alias -Name gcr -Value Use-GitFlowBranchRelease

function Invoke-GitFlow {
    & $git_bin flow @args
}
Set-Alias -Name gfl -Value Invoke-GitFlow

function Invoke-GitFlowFeature {
    & $git_bin flow feature @args
}
Set-Alias -Name gflf -Value Invoke-GitFlowFeature

function Invoke-GitFlowFeatureFinish {
    & $git_bin flow feature finish @args
}
Set-Alias -Name gflff -Value Invoke-GitFlowFeatureFinish

function Invoke-GitFlowFeatureFinishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow feature finish ${$(git_current_branch)#feature/} @args
}
Set-Alias -Name gflffc -Value Invoke-GitFlowFeatureFinishCurrent

function Invoke-GitFlowFeaturePublish {
    & $git_bin flow feature publish @args
}
Set-Alias -Name gflfp -Value Invoke-GitFlowFeaturePublish

function Invoke-GitFlowFeaturePublishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow feature publish ${$(git_current_branch)#feature/} @args
}
Set-Alias -Name gflfpc -Value Invoke-GitFlowFeaturePublishCurrent

function Invoke-GitFlowFeaturePull {
    & $git_bin flow feature pull @args
}
Set-Alias -Name gflfpll -Value Invoke-GitFlowFeaturePull

function Invoke-GitFlowFeatureStart {
    & $git_bin flow feature start @args
}
Set-Alias -Name gflfs -Value Invoke-GitFlowFeatureStart

function Invoke-GitFlowHotfix {
    & $git_bin flow hotfix @args
}
Set-Alias -Name gflh -Value Invoke-GitFlowHotfix

function Invoke-GitFlowHotfixFinish {
    & $git_bin flow hotfix finish @args
}
Set-Alias -Name gflhf -Value Invoke-GitFlowHotfixFinish

function Invoke-GitFlowHotfixFinishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow hotfix finish ${$(git_current_branch)#hotfix/} @args
}
Set-Alias -Name gflhfc -Value Invoke-GitFlowHotfixFinishCurrent

function Invoke-GitFlowHotfixPublish {
    & $git_bin flow hotfix publish @args
}
Set-Alias -Name gflhp -Value Invoke-GitFlowHotfixPublish

function Invoke-GitFlowHotfixPublishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow hotfix publish ${$(git_current_branch)#hotfix/} @args
}
Set-Alias -Name gflhpc -Value Invoke-GitFlowHotfixPublishCurrent

function Invoke-GitFlowHotfixStart {
    & $git_bin flow hotfix start @args
}
Set-Alias -Name gflhs -Value Invoke-GitFlowHotfixStart

function Invoke-GitFlowInit {
    & $git_bin flow init @args
}
Set-Alias -Name gfli -Value Invoke-GitFlowInit

function Invoke-GitFlowRelease {
    & $git_bin flow release @args
}
Set-Alias -Name gflr -Value Invoke-GitFlowRelease

function Invoke-GitFlowReleaseFinish {
    & $git_bin flow release finish @args
}
Set-Alias -Name gflrf -Value Invoke-GitFlowReleaseFinish

function Invoke-GitFlowReleaseFinishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow release finish ${$(git_current_branch)#release/} @args
}
Set-Alias -Name gflrfc -Value Invoke-GitFlowReleaseFinishCurrent

function Invoke-GitFlowReleasePublish {
    & $git_bin flow release publish @args
}
Set-Alias -Name gflrp -Value Invoke-GitFlowReleasePublish

function Invoke-GitFlowReleasePublishCurrent {
    # TODO: fix variable substitution.
    & $git_bin flow release publish ${$(git_current_branch)#release/} @args
}
Set-Alias -Name gflrpc -Value Invoke-GitFlowReleasePublishCurrent

function Invoke-GitFlowReleaseStart {
    & $git_bin flow release start @args
}
Set-Alias -Name gflrs -Value Invoke-GitFlowReleaseStart


Export-ModuleMember -Function * -Alias *
