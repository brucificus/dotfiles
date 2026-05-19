#!/usr/bin/env pwsh

# TODO: write unit tests for this function.
<#
.EXAMPLE
    clip | Format-CopyableJson
#>
Param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [string[]] $InputObject
)

Begin {
    $ErrorActionPreference = "Stop"
    Set-StrictMode -Version Latest
}

Process {
    $InputObject -join "" | ConvertTo-Json -Compress
}
