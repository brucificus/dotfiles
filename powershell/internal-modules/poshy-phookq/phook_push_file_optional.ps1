#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_push_file_optional() {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $path
    )

    $Global:phook_loader_q.Insert(0, [PSCustomObject]@{
        path = $path
        optional = $true
        kind = "file"
    })
}
