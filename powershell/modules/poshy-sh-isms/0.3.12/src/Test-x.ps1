#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-x() {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]
        $Path
    )

    if (Test-Path -ErrorAction SilentlyContinue -Path $path) {
        [bool[]] $isExecutable = Get-Item $Path | ForEach-Object { (Get-ItemNixMode $_.FullName) -band [System.IO.UnixFileMode]::UserExecute }
        return ($isExecutable -notcontains $false)
    } else {
        return $false
    }
}
