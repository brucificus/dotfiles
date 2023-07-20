#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_qsize {
    $Global:phook_loader_q.Count
}
