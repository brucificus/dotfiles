#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-ecks"; RequiredVersion = "0.5.22" }


# A way to use pip without requiring a virtualenv.
function _syspip3() {
    if (-not $Env:PIP3) {
        throw "`$Env:PIP3 is not set."
    }
    xwith @{PIP_REQUIRE_VIRTUALENV=""} {
        & $Env:PIP3 @args
    } @args
}
