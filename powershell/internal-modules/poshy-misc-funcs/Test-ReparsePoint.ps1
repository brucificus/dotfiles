#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Test-ReparsePoint {
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
            $InputObject = Get-Item $Path -Force:$Force
        } else {
            $InputObject = Get-Item -LiteralPath $LiteralPath -Force:$Force
        }
    }
    $InputObject | ForEach-Object { ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 }
}
