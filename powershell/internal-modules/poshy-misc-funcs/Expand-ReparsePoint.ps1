#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Expand-ReparsePoint {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Path')]
        [string] $Path,

        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'LiteralPath')]
        [string] $LiteralPath,

        [Parameter(Mandatory=$false, Position = 1)]
        [switch] $Force,

        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline = $true, ParameterSetName = 'FileSystemInfo')]
        [System.IO.FileSystemInfo[]] $InputObject
    )
    if (@($Path, $LiteralPath)) {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $InputObject = Get-Item -Path $Path -Force:$Force
        } else {
            $InputObject = Get-Item -LiteralPath $LiteralPath -Force:$Force
        }
    }
    $InputObject | ForEach-Object {
        if ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            [string] $targetPath = $_.Target
            if (-not [System.IO.Path]::IsPathRooted($targetPath)) {
                $targetPath = Join-Path -Path $_.FullName -ChildPath $_.Target
            }
            Get-Item -LiteralPath $targetPath -Force:$Force
        } else {
            Write-Error "Not a reparse point: $_"
        }
    }
}
