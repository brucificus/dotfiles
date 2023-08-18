#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# enable color support for grep

if ($Env:CLICOLOR -eq 0) {
    return
}

if (-not (Test-SessionInteractivity)) {
    return
}

if (Test-Command grep) {
    function Invoke-GrepColorfully {
        grep --color=auto @args
    }
    Set-Alias -Name grep -Value Invoke-GrepColorfully
}

if (Test-Command fgrep) {
    function Invoke-FGrepColorfully {
        fgrep --color=auto @args
    }
    Set-Alias -Name fgrep -Value Invoke-FGrepColorfully
}

if (Test-Command egrep) {
    function Invoke-EGrepColorfully {
        egrep --color=auto @args
    }
    Set-Alias -Name egrep -Value Invoke-EGrepColorfully
}
