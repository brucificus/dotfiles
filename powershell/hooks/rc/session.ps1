#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[bool] $VSCODE_HOSTING = $Env:TERM_PROGRAM -eq "vscode"
[bool] $WT_EXISTS = $null -ne (Get-Command wt -ErrorAction SilentlyContinue)
[bool] $WT_HOSTING = $WT_EXISTS ? ($null -ne $Env:WT_SESSION) : $false


if ($WT_EXISTS)
{
    phook_enqueue_module poshy-wt

    if ($WT_HOSTING) {
        function New-Tab {
            New-WindowsTerminalTab -currentWindow @args
        }

        function New-Pane {
            New-WindowsTerminalPane -currentWindow @args
        }
    }
}

Set-Alias -Name dfu -Value dotfiles_update

function q {
    if ($args) {
        [System.Environment]::Exit($args[0])
    } else {
        [System.Environment]::Exit(0)
    }
}

if (Get-Alias notify-send -ErrorAction SilentlyContinue) {
    [string] $notify_send_implementation = (Get-Alias notify-send).Definition
    if ($notify_send_implementation -ne "notify-send-fallback") {
        # Add an "alert" alias for long running commands.  Use like so:
        #   sleep 10; alert
        function alert() {
            $previous_LASTEXITCODE = $LASTEXITCODE
            $last_command = Get-History -Count 1
            $kind = $previous_LASTEXITCODE -eq 0 ? "terminal" : "error"
            notify-send -Title $kind -Message "Finished running `"$last_command`""
        }
    }
    elseif (-not $IsWSL) {
        append_profile_suggestions "# TODO: 🛎️ Install 'notify-send'. See: https://ss64.com/bash/notify-send.html."
    }
}

Set-Alias -Name hist -Value Get-History

function hist10 {
    Get-History -Count 10 | Sort-Object -Property Id -Descending
}
