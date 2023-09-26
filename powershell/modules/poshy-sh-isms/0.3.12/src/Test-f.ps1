#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-f() {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]
        $Path
    )
    return (Test-Path -ErrorAction SilentlyContinue -PathType Leaf -Path $Path)
}
