
$VSCODE = Get-Command -ErrorAction SilentlyContinue code | Select-Object -ExpandProperty Source
$NANO = Get-Command -ErrorAction SilentlyContinue nano | Select-Object -ExpandProperty Source
$NEOVIM = Get-Command -ErrorAction SilentlyContinue nvim | Select-Object -ExpandProperty Source
$VIM = Get-Command -ErrorAction SilentlyContinue vim | Select-Object -ExpandProperty Source
$VI = Get-Command -ErrorAction SilentlyContinue vi | Select-Object -ExpandProperty Source

$GITBASH_NANO = Join-Path $Env:ProgramW6432 'Git\usr\bin\nano.exe'
if (-not (Test-Path $GITBASH_NANO -ErrorAction SilentlyContinue)) {
    $GITBASH_NANO = $null
}

$NANO_ARGS = [System.Collections.ArrayList]@('--stateflags', '--linenumbers', '--noconvert', '--minibar', '--mouse', '--magic', '--positionlog', '--indicator')
if ($IsWindows) {
    $NANO_ARGS.Add('--noconvert')
}
if ($IsLinux) {
    $NANO_ARGS.Add('--unix')
}

if ($NANO -or $GITBASH_NANO) {
    $NANO_HELP = $NANO ? (nano -h) : (&$GITBASH_NANO -h)
    $NANO_ARGS `
    | Where-Object { -not ($NANO_HELP -match $_) } `
    | ForEach-Object { $NANO_ARGS.Remove($_) }
}


#
# Setup preferred editor.
#

if ($VSCODE -and $Env:VSCODE_GIT_IPC_HANDLE) {
    # If we are in VSCode's embedded terminal,
    # …let's try to reuse the VSCode window.
    $VSCODE_ARGS = @('--reuse-window', '--wait')
    function edit {
        code @VSCODE_ARGS $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "code $VSCODE_ARGS"
} elseif ($VSCODE -and (-not $Env:SSH_CONNECTION)) {
    # If we are NOT in VSCode's embedded terminal,
    # (and we are NOT in an SSH session)
    # …let's always open a new VSCode window.
    $VSCODE_ARGS = @('--new-window', '--wait')
    function edit {
        code @VSCODE_ARGS $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "code $VSCODE_ARGS"
} elseif ($NANO) {
    # If nano exists, let's use it.
    function edit {
        nano @NANO_ARGS $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "nano $NANO_ARGS"
} elseif ($GITBASH_NANO) {
    # If nano exists via Git Bash, let's use it.
    function edit {
        &$GITBASH_NANO @NANO_ARGS $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "`"$GITBASH_NANO`" $NANO_ARGS"
} elseif ($NEOVIM) {
    # If neovim exists, let's use it.
    function edit {
        nvim $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "nvim"
} elseif ($VIM) {
    # If vim exists, let's use it.
    function edit {
        vim $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "vim"
} elseif ($VI) {
    # If vi exists, let's use it.
    function edit {
        vi $args
    }
    Set-EnvVar -Process -Name EDITOR -Value "vi"
} else {
    if ($IsWindows -and (Get-Command -ErrorAction SilentlyContinue notepad)) {
        # If we are on Windows, let's fall back to notepad.
        function edit {
            notepad $args
        }
        Set-EnvVar -Process -Name EDITOR -Value "notepad"
    } elseif ($IsLinux) {
        # If we are on Linux, let's fall back to ed.
        function edit {
            ed $args
        }
        Set-EnvVar -Process -Name EDITOR -Value "ed"
    } else {
        # No editor found.
    }
}
if (Get-Command edit -ErrorAction SilentlyContinue) {
    Export-ModuleMember -Function edit
}


#
# Setup preferred viewers.
#

if (Get-Alias cat -ErrorAction SilentlyContinue) {
    Remove-Alias -Name cat
}
$CAT = Get-Command -ErrorAction SilentlyContinue cat | Select-Object -ExpandProperty Source

$BATCAT = Get-Command -ErrorAction SilentlyContinue batcat | Select-Object -ExpandProperty Source
if ($BATCAT) {
    function batcat {
        batcat $args
    }
    Set-Alias -Name cat -Value batcat
} elseif (-not $CAT) {
    Set-Alias -Name cat -Value Get-Content
}
Export-ModuleMember -Alias cat


$VIEWER_BATCAT_ARGS=@()
$VIEWERB_BATCAT_ARGS=$VIEWER_BATCAT_ARGS + @('--show-all')

$VIEWER_NANO_ARGS=$NANO_ARGS + @('--view')

$VIEWER_CAT_ARGS=@('--number')
$VIEWERB_CAT_ARGS=$VIEWER_CAT_ARGS + @('--show-all')

# We don't use VSCode because it doesn't currently support being launched in a read-only mode.
if ($BATCAT) {
    # If batcat exists, let's use it.
    function view {
        batcat $VIEWER_BATCAT_ARGS $args
    }
    function viewb {
        batcat $VIEWERB_BATCAT_ARGS $args
    }
} elseif ($NANO) {
    # If nano exists, let's use it for non-binary viewing.
    function view {
        nano $VIEWER_NANO_ARGS $args
    }
    # (We don't use nano for binary viewing because it doesn't support displaying non-printable characters.)
} elseif ($GITBASH_NANO) {
    # If nano exists via Git Bash, let's use it for non-binary viewing.
    function view {
        &$GITBASH_NANO $VIEWER_NANO_ARGS $args
    }
    # (We don't use nano for binary viewing because it doesn't support displaying non-printable characters.)
} elseif ($CAT) {
    # If cat exists, let's use it.
    function view {
        cat $VIEWER_CAT_ARGS $args
    }
    if (-not (Get-Command viewb -ErrorAction SilentlyContinue)) {
        function viewb {
            cat $VIEWERB_CAT_ARGS $args
        }
    }
} else {
    # No viewer found.
}
if (Get-Command view -ErrorAction SilentlyContinue) {
    Export-ModuleMember -Function view
}
if (Get-Command viewb -ErrorAction SilentlyContinue) {
    Export-ModuleMember -Function viewb
}
