#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Oh-My-Zsh's lib/termsupport.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/cb8b677488c7a20278917af58dfccd72cd40e1b1/lib/termsupport.zsh


# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)
function title {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $short_tab_title,

        [Parameter(Mandatory = $false, Position = 1)]
        [string] $long_window_title = $null
    )

    # Don't set the title if inside emacs, unless using vterm
    if ($Env:INSIDE_EMACS -and $Env:INSIDE_EMACS -ne "vterm") {
        return
    }

    # if $long_window_title is unset use $short_tab_title as default
    # if it is set and empty, leave it as is
    if (-not $PSBoundParameters.Contains("long_window_title")) {
        $long_window_title = $short_tab_title
    }

    [string[]] $windowAndTabTerminals = @(
        cygwin
        xterm*
        putty*
        rxvt*
        konsole*
        ansi
        mlterm*
        alacritty
        st*
        foot
        contour*
    )
    [string[]] $screenHardstatusTerminals = @(
        screen*
        tmux*
    )

    if ($windowAndTabTerminals | Where-Object { $Env:TERM -like $_ }) {
        Write-Host -NoNewline "`e]2;$short_tab_title`a" # set window name
        Write-Host -NoNewline "`e]1;$long_window_title`a" # set tab name
    }
    elseif ($screenHardstatusTerminals | Where-Object { $Env:TERM -like $_ }) {
        Write-Host -NoNewline "`ek$long_window_title`e\\" # set screen hardstatus
    }
    else {
        if ($Env:TERM_PROGRAM -eq "iTerm.app") {
            Write-Host -NoNewline "`e]2;$short_tab_title`a" # set window name
            Write-Host -NoNewline "`e]1;$long_window_title`a" # set tab name
        }
        # TODO: terminfo (the variable) support, ala Zsh.
        # else {
        #     # Try to use terminfo to set the title if the feature is available
        #     if ($terminfo["fsl"] -and $terminfo["tsl"]) {
        #         Write-Host -NoNewline "$($terminfo["tsl"])$long_window_title$($terminfo["fsl"])"
        #     }
        # }
    }
}

if (-not (Test-Path function:PWSHRC_TERM_TAB_TITLE_IDLE -ErrorAction SilentlyContinue)) {
    #15 char left truncated PWD
    function PWSHRC_TERM_TAB_TITLE_IDLE {
        [string] $dir = Get-Location
        if ($dir.StartsWith($HOME)) {
            $dir = "~" + $dir.Substring($HOME.Length)
        }
        if ($dir.Length -gt 15) {
            $dir = "…$($dir.Substring($dir.Length - 14))"
        }
        return $dir
    }
}

if (-not (Test-Path function:PWSHRC_TERM_TITLE_IDLE -ErrorAction SilentlyContinue)) {
    [string[]] $termProgramsWithIndependentDirDisplay = @(
        "Apple_Terminal"
    )
    [bool] $inTermProgramsWithIndependentDirDisplay = $Env:TERM_PROGRAM -in $termProgramsWithIndependentDirDisplay
    Remove-Variable -Name termProgramsWithIndependentDirDisplay

    if (-not $inTermProgramsWithIndependentDirDisplay) {
        # <username>@<hostname>:<current directory>
        function PWSHRC_TERM_TITLE_IDLE {
            [string] $dir = Get-Location
            if ($dir.StartsWith($HOME)) {
                $dir = "~" + $dir.Substring($HOME.Length)
            }
            return "${Env:USERNAME}@$(hostname):${dir}"
        }
    }
    else {
        # Avoid duplication of directory in terminals with independent dir display.
        # <username>@<hostname>
        function PWSHRC_TERM_TITLE_IDLE {
            return "${Env:USERNAME}@$(hostname)"
        }
    }
    Remove-Variable -Name inTermProgramsWithIndependentDirDisplay
}

# Runs before showing the prompt
function pwshrc_termsupport_precmd {
    if ($Env:DISABLE_AUTO_TITLE) {
        return
    }
    title (PWSHRC_TERM_TAB_TITLE_IDLE) (PWSHRC_TERM_TITLE_IDLE)
}

# Runs before executing the command
function pwshrc_termsupport_preexec {
    param(
        [string] $1,
        [string] $2
    )

    if ($Env:DISABLE_AUTO_TITLE) {
        return
    }

    # split command into array of arguments
    [string[]] $cmdargs = ($2 -split " ")
    # if running fg, extract the command from the job description
    if ( $cmdargs[0] -eq "fg" ) {
        # get the job id from the first argument passed to the fg command
        [string] $job_id
        [string] $jobspec = "${cmdargs[2]#%}"
        # logic based on jobs arguments:
        # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
        # https://www.zsh.org/mla/users/2007/msg00704.html
        if ([int]::TryParse($jobspec, [ref]$null)) {
            # %number argument:
            # use the same <number> passed as an argument
            # suspended:+:5071=suspended (tty output)
            $job_id = $jobspec
        }
        elseif (($jobspec -eq [string]::Empty) -or ($jobspec -eq "%") -or ($jobspec -eq "+")) {
            # empty, %% or %+ argument:
            # use the current job, which appears with a + in $jobstates:
            # suspended:+:5071=suspended (tty output)
            # TODO: $job_id=${(k)jobstates[(r)*:+:*]}
            throw [System.NotImplementedException]::new()
        }
        elseif ($jobspec -eq "-") {
            # %- argument:
            # use the previous job, which appears with a - in $jobstates:
            # suspended:-:6493=suspended (signal)
            # TODO: $job_id=${(k)jobstates[(r)*:-:*]}
            throw [System.NotImplementedException]::new()
        }
        elseif ($jobspec.StartsWith("?")) {
            # %?string argument:
            # use $jobtexts to match for a job whose command *contains* <string>
            # TODO: $job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]}
            throw [System.NotImplementedException]::new()
        }
        else {
            # %string argument:
            # use $jobtexts to match for a job whose command *starts with* <string>
            # TODO: $job_id=${(k)jobtexts[(r)${(Q)jobspec}*]}
            throw [System.NotImplementedException]::new()
        }

        # override preexec function arguments with job command
        if ($jobtexts[$job_id]) {
            $1 = $jobtexts[$job_id]
            $2 = $jobtexts[$job_id]
        }
    }

    # cmd name only, or if this is sudo or ssh, the next cmd
    [string] $CMD = $1
    $CMD = $CMD -replace "^([^\s=]+=[^\s]|sudo|ssh|mosh|rake|-[^\s]+)", ""
    $CMD = [Uri]::EscapeDataString($CMD)
    [string] $LINE = [Uri]::EscapeDataString($2)

    if ($LINE.Length -lt 100) {
        $LINE = $LINE.PadLeft(100)
    }
    elseif ($LINE.Length -gt 100) {
        $LINE = "…" + $LINE.Substring($LINE.Length - 99)
    }

    title $CMD $LINE
}

try {
    if ((-not $Env:INSIDE_EMACS) || ($Env:INSIDE_EMACS -eq "vterm")) {
        # TODO: add-pwsh-precmd-hook pwshrc_termsupport_precmd
        # TODO: add-pwsh-preexec-hook pwshrc_termsupport_preexec
    }

    # Keep terminal emulator's current working directory correct,
    # even if the current working directory path contains symbolic links
    #
    # References:
    # - Apple's Terminal.app: https://superuser.com/a/315029
    # - iTerm2: https://iterm2.com/documentation-escape-codes.html (iTerm2 Extension / CurrentDir+RemoteHost)
    # - Konsole: https://bugs.kde.org/show_bug.cgi?id=327720#c1
    # - libvte (gnome-terminal, mate-terminal, …): https://bugzilla.gnome.org/show_bug.cgi?id=675987#c14
    #   Apparently it had a bug before ~2012 were it would display the unknown OSC 7 code
    #
    # As of May 2021 mlterm, PuTTY, rxvt, screen, termux & xterm simply ignore the unknown OSC.

    # Don't define the function if we're inside Emacs or in an SSH session.
    if ($Env:INSIDE_EMACS -or $Env:SSH_CLIENT -or $Env:SSH_TTY) {
        return
    }

    # Don't define the pwshrc_termsupport_cwd function if we're in an unsupported terminal

    # all of these either process OSC 7 correctly or ignore entirely
    [string[]] $osc7TolerantTerminals = @(
        "xterm*"
        "putty*"
        "rxvt*"
        "konsole*"
        "mlterm*"
        "alacritty"
        "screen*"
        "tmux*"
        "contour*"
        "foot*"
    )
    [string[]] $osc7TolerantTerminalApps = @(
        "Apple_Terminal"
        "iTerm.app"
    )
    [bool] $inOsc7TolerantTerminal = @(
        $osc7TolerantTerminals | Where-Object { $Env:TERM -like $_ }
    ).Length -gt 0
    [bool] $inOsc7TolerantTerminalApp = @(
        $osc7TolerantTerminalApps | Where-Object { $Env:TERM_PROGRAM -eq $_ }
    ).Length -gt 0
    if ((-not $inOsc7TolerantTerminal) -and (-not $inOsc7TolerantTerminalApp)) {
        return
    }

}
finally {
    Remove-Variable -Name inOsc7TolerantTerminal -ErrorAction SilentlyContinue
    Remove-Variable -Name inOsc7TolerantTerminalApp -ErrorAction SilentlyContinue
    Remove-Variable -Name osc7TolerantTerminalApps -ErrorAction SilentlyContinue
    Remove-Variable -Name osc7TolerantTerminals -ErrorAction SilentlyContinue
}

# Emits the control sequence to notify many terminal emulators
# of the cwd
#
# Identifies the directory using a file: URI scheme, including
# the host name to disambiguate local vs. remote paths.
function pwshrc_termsupport_cwd {
    # Percent-encode the host and path names.
    [string] $URL_HOST = [System.Uri]::EscapeDataString((hostname))
    [string] $URL_PATH = [System.Uri]::EscapeDataString((Get-Location))

    # Konsole errors if the HOST is provided
    if ($Env:TERM_PROGRAM -eq "konsole") {
        $URL_HOST = ""
    }

    # common control sequence (OSC 7) to set current host and path
    Write-Host -NoNewline "`e]7;file://${URL_HOST}${URL_PATH}`e\"
}

# Use a precmd hook instead of a chpwd hook to avoid contaminating output
# i.e. when a script or function changes directory without `cd -q`, chpwd
# will be called the output may be swallowed by the script or function.
# TODO: add-pwsh-precmd-hook pwshrc_termsupport_cwd
