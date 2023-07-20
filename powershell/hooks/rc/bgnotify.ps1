#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Oh-My-Zsh's bgnotify.plugin.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/f4dc8c5be365668810783ced01a86ff8f251bfd7/plugins/bgnotify/bgnotify.plugin.zsh


if (-not (Get-Alias notify-send -ErrorAction SilentlyContinue)) {
    Import-Module poshy-notify-send -DisableNameChecking
}
if (-not (Get-Alias notify-send -ErrorAction SilentlyContinue)) {
    return
}
[string] $notify_send_implementation = (Get-Alias notify-send).Definition
if ($notify_send_implementation -eq "notify-send-fallback") {
    return
}

# notify if command took longer than 5s by default
Set-Variable -Name bgnotify_threshold -Value ($Global:bgnotify_threshold ?? ([TimeSpan]::FromSeconds(5)))

function bgnotify_begin {
    Set-Variable -Name bgnotify_timestamp -Value [DateTimeOffset]::UtcNow -Option Global
    Set-Variable -Name bgnotify_lastcmd -Value ($args | Select-Object -First 1) -Option Global
}

function bgnotify_end {
    try {
        [int] $exit_status = $LASTEXITCODE

        if (-not ($Global:bgnotify_timestamp)) {
            return
        }

        [TimeSpan] $elapsed=([DateTimeOffset]::UtcNow - $Global:bgnotify_timestamp)

        # check time elapsed
        if ($elapsed -lt $Global:bgnotify_threshold) {
            return
        }

        # TODO: This is pseudocode - the function `get-current-appid-windowid-pair` isn't accessible from here,
        #       (and probably shouldn't be).
        #       We don't need to get this working until we both A) have prompt hooks (e.g. the blocker for all of bgnotify stuff here),
        #       and B) we're trying to get this working on a MacOS system (probably). (Guessing based on context of original code.)
        #
        # # check if Terminal app is not active
        # if (-not $Global:notifysend_appid_windowid_pair) {
        #     Receive-Job -Job $Global:notifysend_appid_windowid_pair_retrieval_job -Keep
        # }
        # if (get-current-appid-windowid-pair -ne $Global:notifysend_appid_windowid_pair) {
        #     return
        # }

        [Console]::Beep()
        bgnotify_formatted $exit_status $bgnotify_lastcmd $elapsed
    }
    finally {
        Remove-Variable -Name bgnotify_timestamp -Scope Global
        Remove-Variable -Name bgnotify_lastcmd -Scope Global
    }
}

function bgnotify_formatted {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [int] $exit_status,

        [Parameter(Mandatory=$true, Position=1)]
        [string] $command,

        [Parameter(Mandatory=$true, Position=2)]
        [TimeSpan] $elapsed
    )

    # humanly readable elapsed time
    if ($elapsed.TotalSeconds -lt 60) {
        $elapsed = "{0:0}s" -f $elapsed.TotalSeconds
    } elseif ($elapsed.TotalMinutes -lt 60) {
        $elapsed = "{0:0}m {1:0}s" -f $elapsed.TotalMinutes, $elapsed.Seconds
    } elseif ($elapsed.TotalHours -lt 24) {
        $elapsed = "{0:0}h {1:0}m {2:0}s" -f $elapsed.TotalHours, $elapsed.Minutes, $elapsed.Seconds
    } elseif ($elapsed.TotalDays -lt 7) {
        $elapsed = "{0:0}d {1:0}h {2:0}m {3:0}s" -f $elapsed.TotalDays, $elapsed.Hours, $elapsed.Minutes, $elapsed.Seconds
    } elseif ($elapsed.TotalDays -lt 365.25 ) {
        $elapsed = "{0:0}w {1:0}d {2:0}h {3:0}m {4:0}s" -f $elapsed.TotalDays / 7, $elapsed.TotalDays % 7, $elapsed.Hours, $elapsed.Minutes, $elapsed.Seconds
    } else {
        $elapsed = "{0:0}y {1:0}w {2:0}d {3:0}h {4:0}m {5:0}s" -f $elapsed.TotalDays / 365.25, ($elapsed.TotalDays % 365.25) / 7, $elapsed.TotalDays % 7, $elapsed.Hours, $elapsed.Minutes, $elapsed.Seconds
    }

    if ($exit_status -eq 0) {
        [string] $status = "#win"
    } else {
        [string] $status = "#fail"
    }

    if ((Get-Command $notify_send_implementation -Syntax) -like "*-TimeoutSeconds*") {
        notify-send -Title $status -Message "$command" -TimeoutSeconds 5
    } else {
        notify-send -Title $status -Message "$command"
    }
}

# add-pwsh-preexec-hook bgnotify_begin
# add-pwsh-precmd-hook bgnotify_end
