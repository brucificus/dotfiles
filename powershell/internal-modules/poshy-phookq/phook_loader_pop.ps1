#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_loader_pop() {
    param()

    if ($Global:phook_loader_q.Count -eq 0) {
        return $null
    } else {
        [object] $result = ($Global:phook_loader_q)[0]
        $Global:phook_loader_q.RemoveAt(0)
        return $result
    }
}
