#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function _pip3() {
    if (-not $Env:PIP3) {
        throw "`$Env:PIP3 is not set."
    }
    & $Env:PIP3 @args
}
