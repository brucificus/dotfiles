#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function phook_enqueue_module() {
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [object] $module
    )

    if ($module -is [System.IO.FileSystemInfo]) {
        $module = $module.FullName
    } elseif ($module -is [System.Management.Automation.PSModuleInfo]) {
        $module = $module.Name
    } elseif ($module -isnot [string]) {
        throw [System.ArgumentException]::new("Expected a path or module info object.")
    }

    $Global:phook_loader_q.Add([PSCustomObject]@{
        path = $module
        optional = $false
        kind = "module"
    }) | Out-Null
}
