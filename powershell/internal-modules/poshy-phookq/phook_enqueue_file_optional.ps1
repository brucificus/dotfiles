#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_enqueue_file_optional() {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $path
    )

    $Global:phook_loader_q.Add([PSCustomObject]@{
        path = $path
        optional = $true
        kind = "file"
    }) | Out-Null
}
