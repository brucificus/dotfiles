#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function _syspip3_package_location() {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $PackageName
    )

    $syspip_show_package = (_syspip3 show $PackageName)
    if ($syspip_show_package) {
        $ds = [System.IO.Path]::DirectorySeparatorChar
        return ($syspip_show_package -split '\r?\n' | Where-Object { $_ -like 'Location: *' } | ForEach-Object { $_.Substring(10) + $ds + $PackageName })
    } else {
        return $null
    }
}
