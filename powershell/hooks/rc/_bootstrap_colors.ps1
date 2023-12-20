#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Christian Ludwig's zsh-256color.plugin.zsh, see: https://github.com/chrissicool/zsh-256color/blob/243df6354eb4a7addbb47ba13b332398582be7f4/zsh-256color.plugin.zsh



# Configure environment variables that control colorized output.
# Sets 256color terminal mode if available.

# NOTE: We don't skip *any* of this logic for non-interactive terminals, because non-interactive terminals are often still _visible_ to the user.
#       We also always load the poshy-colors module, because its functions may be referenced regardless as to color availability.

phook_push_module "poshy-colors"

# Normalize the color variables.
if ($Env:NO_COLOR -in @(1, "true")) {
    Set-EnvVar -Process -Name "NO_COLOR" -Value 0
    Set-EnvVar -Process -Name "CLICOLOR" -Value 0
    Set-EnvVar -Process -Name "TERM_ITALICS" -Value 0
    return
}

if (-not ($Env:CLICOLOR -in @(1, "true"))) {
    return
}

if ($Env:NO_COLOR) {
    Remove-EnvVar -Process -Name "NO_COLOR"
}
Set-EnvVar -Process -Name "CLICOLOR" -Value 1
Set-EnvVar -Process -Name "TERM_ITALICS" -Value 1

# Special-case Windows Terminal.
if ($Env:WT_SESSION) {
    Write-Debug "Windows Terminal detected. Skipping 256-color terminal detection and assuming truecolor."
    if ($Env:TERM -notlike "*-256color") {
        Set-EnvVar -Process -Name TERM -Value "${Env:TERM}-256color"
    }
    if (-not $Env:COLORTERM) {
        Set-EnvVar -Process -Name COLORTERM -Value "truecolor"
    }
}

if ( $Env:TERM -like "*-256color" ) {
    Write-Debug "256 color terminal already set."
    return
}

# Try a little bit harder to see if 256 color terminal is available…

$TERM256="${Env:TERM}-256color"

# Use (n-)curses binaries, if installed.
if (Test-Command toe) {
    $toe = (toe -a)
    if ($toe -match "^$TERM256") {
        Write-Debug "Found $TERM256 from (n-)curses binaries."
        Set-EnvVar -Process -Name TERM -Value $TERM256
        return
    }
}

# Search through termcap descriptions, if binaries are not installed.
$ds = [System.IO.Path]::DirectorySeparatorChar
try {
    [string[]] $termcapDescriptionFiles = @(
        $Env:TERMCAP
        "${Env:HOME}${ds}.termcap"
        "/etc/termcap"
        "/etc/termcap.small"
    )
    foreach ($termcapDescriptionFile in $termcapDescriptionFiles) {
        if ((Test-Path -Path $termcapDescriptionFile) -and ((Get-Content -Path $termcapDescriptionFile) -match "(^$TERM256|\|$TERM256)\|")) {
            Write-Debug "Found $TERM256 from $termcapDescriptionFile."
            Set-EnvVar -Process -Name TERM -Value $TERM256
            return
        }
    }

    # Search through terminfo descriptions, if binaries are not installed.
    [string[]] $terminfoDescriptionFolders = @(
        $Env:TERMINFO
        "${Env:HOME}${ds}.terminfo"
        "/etc/terminfo"
        "/lib/terminfo"
        "/usr/share/terminfo"
    )
    foreach ($terminfoDescriptionFolder in $terminfoDescriptionFolders) {
        if (Test-Path -Path $terminfoDescriptionFolder) {
            if (Get-ChildItem -Path $terminfoDescriptionFolder -Recurse -Include $TERM256 -ErrorAction SilentlyContinue) {
                Write-Debug "Found $TERM256 from $terminfoDescriptionFolder."
                Set-EnvVar -Process -Name TERM -Value $TERM256
                return
            }
        }
    }
}
finally {
    Remove-Variable -Name ds
}

# The MIT License (MIT)
# Copyright ©️ 2014-2019 Christian Ludwig
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
