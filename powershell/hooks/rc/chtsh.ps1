#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if ($IsWindows -and (Test-Command cht.exe)) {
    function cht.sh {
        param(
            [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
            [string[]] $Query
        )
        if ($Env:CLICOLOR -eq 0) {
            cht.exe --no_colors --query @Query
        } else {
            cht.exe --query @Query
        }
    }
} elseif (Test-Command cht.sh) {
    [string] $chtsh_bin = Search-CommandPath cht.sh
    function cht.sh {
        param(
            [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
            [string[]] $Query
        )
        & $chtsh_bin @Query
    }
} elseif (-not (Test-Command cht.sh)) {
    function cht.sh {
        param(
            [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
            [string[]] $Query
        )
        [string] $queryAsUrlPart = $Query -join "/ "
        $url = "https://cht.sh/$queryAsUrlPart"
        Invoke-RestMethod $url
    }
    append_profile_suggestions "# TODO: 📔 Install 'cht.sh'. See: https://github.com/chubin/cheat.sh#installation."
}
