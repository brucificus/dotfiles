#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command brew)) {
    return
}

function Invoke-BrewUpdateAndOutdatedCask {
    brew update
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    brew outdated --cask @args
}
Set-Alias -Name bcubo -Value Invoke-BrewUpdateAndOutdatedCask

function Invoke-BrewUpgradeCaskAndCleanup {
    brew upgrade --cask
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    brew cleanup @args
}
Set-Alias -Name bcubc -Value Invoke-BrewUpgradeCaskAndCleanup

function Invoke-BrewPin {
    brew pin @args
}
Set-Alias -Name brewp -Value Invoke-BrewPin

function Invoke-BrewListPinned {
    brew list --pinned @args
}
Set-Alias -Name brewsp -Value Invoke-BrewListPinned

function Invoke-BrewUpgradeAndCleanup {
    brew upgrade
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    brew cleanup @args
}
Set-Alias -Name bubc -Value Invoke-BrewUpgradeAndCleanup

function Invoke-BrewUpgradeGreedyAndCleanup {
    brew upgrade --greedy
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    brew cleanup @args
}
Set-Alias -Name bugbc -Value Invoke-BrewUpgradeGreedyAndCleanup

function Invoke-BrewUpdateAndOutdated {
    brew update
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    brew outdated @args
}
Set-Alias -Name bubo -Value Invoke-BrewUpdateAndOutdated

function Invoke-BrewUpdateAndOutdatedAndUpgradeAndCleanup {
    Invoke-BrewUpdateAndOutdated @args
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Invoke-BrewUpgradeAndCleanup @args
}
Set-Alias -Name bubu -Value Invoke-BrewUpdateAndOutdatedAndUpgradeAndCleanup

function Invoke-BrewUpdateAndOutdatedAndUpgradeGreedyAndCleanup {
    Invoke-BrewUpdateAndOutdated @args
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Invoke-BrewUpgradeGreedyAndCleanup @args
}
Set-Alias -Name bubug -Value Invoke-BrewUpdateAndOutdatedAndUpgradeGreedyAndCleanup

function Invoke-BrewUpgradeFormula {
    brew upgrade --formula @args
}
Set-Alias -Name bfu -Value Invoke-BrewUpgradeFormula

function Invoke-BrewUninstallZap {
    brew uninstall --zap @args
}
Set-Alias -Name buz -Value Invoke-BrewUninstallZap


Export-ModuleMember -Function * -Alias *
