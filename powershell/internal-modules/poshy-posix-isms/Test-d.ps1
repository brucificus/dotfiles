#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-d() {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]
        $Path
    )
    return (Test-Path -ErrorAction SilentlyContinue -PathType Container -Path $Path)
}
