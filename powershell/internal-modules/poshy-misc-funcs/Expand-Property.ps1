#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Expand-Property {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [PSObject[]] $inputObjects,
        [Parameter(Mandatory = $true, Position = 0)] [string[]] $propertyChain
    )

    [PSObject[]] $results = $inputObjects
    foreach($property in $propertyChain) {
        $results = $results | Select-Object -ExpandProperty $property
    }

    return $results
}
