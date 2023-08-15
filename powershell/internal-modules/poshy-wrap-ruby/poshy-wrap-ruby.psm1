#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Invoke-Ruby {
    ruby @args
}
Set-Alias -Name rb -Value Invoke-Ruby

# Find ruby file
function Invoke-RubyFind {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $pattern
    )
    Get-ChildItem -Filter *.rb -Recurse -File | ForEach-Object {
        Get-Content $_.FullName | Select-String -Pattern $pattern | ForEach-Object {
            [PSCustomObject]@{
                File = $_.Path
                Line = $_.LineNumber
                Text = $_.Line
            }
        }
    }
}
Set-Alias -Name rfind -Value Invoke-RubyFind

function Invoke-RubyExecute {
    ruby -e @args
}
Set-Alias -Name rrun -Value Invoke-RubyExecute

function Invoke-RubyExecuteHttpdHere {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int] $port = 8080
    )
    # requires webrick
    ruby -e httpd . -p $port
}
Set-Alias -Name rserver -Value Invoke-RubyExecuteHttpdHere


Export-ModuleMember -Function * -Alias *
