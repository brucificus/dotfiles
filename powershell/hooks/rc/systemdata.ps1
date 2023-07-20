Set-Alias -Name usage -Value Get-ChildItemDiskUsage
if ($IsWindows) {
    Set-Alias -Name du -Value Get-ChildItemDiskUsage
}


function psmem {
    Get-Process | Sort-Object -Property WS -Descending | Select-Object -Property Id, WS, ProcessName, CommandLine
}

function psmem10 {
    psmem | Select-Object -First 10
}

function pscpu {
    Get-Process | Sort-Object -Property CPU -Descending | Select-Object -Property Id, CPU, ProcessName, CommandLine
}

function pscpu10 {
    pscpu | Select-Object -First 10
}

function psgrep {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Pattern
    )
    Get-Process | Where-Object { $_.CommandLine -match $Pattern }
}

function pslike {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Pattern
    )
    Get-Process | Where-Object { $_.CommandLine -like $Pattern }
}
