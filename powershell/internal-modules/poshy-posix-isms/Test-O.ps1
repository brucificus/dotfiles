#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-O() {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]
        $Path
    )

    if (Test-Path -ErrorAction SilentlyContinue -Path $path) {
        [System.IO.FileSystemInfo[]] $info = $path | Get-Item
        if (Get-Command Get-Acl -ErrorAction SilentlyContinue) {
            [System.Security.AccessControl.FileSystemSecurity[]] $acl = $info | Get-Acl
            [string] $currentUser = whoami
            [bool[]] $isOwner = $acl | Select-Object -ExpandProperty Access | ForEach-Object { $_.IdentityReference -eq $currentUser  }
            return ($isOwner -notcontains $false)
        } elseif (@($info | Get-Member User -ErrorAction SilentlyContinue)) {
            [string] $currentUser = whoami
            [bool[]] $isOwner = $info | Select-Object -ExpandProperty User | ForEach-Object { $_ -eq $currentUser  }
            return ($isOwner -notcontains $false)
        } else {
            throw [System.PlatformNotSupportedException]::new()
        }
    } else {
        return $false
    }
}
