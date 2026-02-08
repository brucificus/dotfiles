#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
param(
    [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]] $rest = $null,

    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline)]
    [object] $InputObject = $null
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# First, validate colorization configuration & availability.
$tools = @("batcat", "pygmentize", "chroma")
if (-not "$Env:PWSHRC_COLORIZE_TOOL") {
    foreach ($tool in $tools) {
        if (Test-Command $tool) {
            $Env:PWSHRC_COLORIZE_TOOL=$tool
            break
        }
    }
    if (-not "$Env:PWSHRC_COLORIZE_TOOL") {
        throw "Neither 'batcat' nor 'pygments' nor 'chroma' is installed."
    }
} elseif (-not (Test-Command $Env:PWSHRC_COLORIZE_TOOL)) {
    throw "Tool '$Env:PWSHRC_COLORIZE_TOOL' is not installed!"
} elseif (-not ($Env:PWSHRC_COLORIZE_TOOL -in $tools)) {
    throw "Tool '$Env:PWSHRC_COLORIZE_TOOL' is not recognized. Available options are 'batcat', 'pygmentize', and 'chroma'."
}


# If the environment variable PWSHRC_COLORIZE_STYLE
# is set, use that theme instead. Otherwise,
# use the default.
if (-not $Env:PWSHRC_COLORIZE_STYLE) {
    if ($Env:PWSHRC_COLORIZE_TOOL -eq "batcat") {
        if ($Env:BATCAT_THEME) {
            $Env:PWSHRC_COLORIZE_STYLE=$Env:BATCAT_THEME
        } else {
            $Env:PWSHRC_COLORIZE_STYLE="ansi"
        }
    } else {
        # Both pygmentize & chroma support 'emacs'
        $Env:PWSHRC_COLORIZE_STYLE="emacs"
    }
}

# Use stdin if no arguments have been passed, or if an arg is "-".
if (($rest.Length -eq 0) -or ("-" -in $rest)) {
    switch ($Env:PWSHRC_COLORIZE_TOOL) {
        "batcat" {
            $InputObject | batcat --style="$Env:PWSHRC_COLORIZE_STYLE" --color=always @rest
        }
        "pygmentize" {
            $InputObject | pygmentize -O style="$Env:PWSHRC_COLORIZE_STYLE" -g @rest
        }
        "chroma" {
            $PWSHRC_COLORIZE_CHROMA_FORMATTER = $Env:PWSHRC_COLORIZE_CHROMA_FORMATTER ?? "terminal"
            $InputObject | chroma --style="$Env:PWSHRC_COLORIZE_STYLE" --formatter="$PWSHRC_COLORIZE_CHROMA_FORMATTER" @rest
        }
    }
    exit $LASTEXITCODE
}

# Guess lexer from file extension, or guess it from file contents if unsuccessful.
foreach ($fname in $rest) {
    switch ($Env:PWSHRC_COLORIZE_TOOL) {
        "batcat" {
            batcat --theme="$Env:PWSHRC_COLORIZE_STYLE" --color=always @rest
        }
        "pygmentize" {
            $lexer=$(pygmentize -N "$FNAME")
            if ($lexer -ne "text") {
                pygmentize -O style="$Env:PWSHRC_COLORIZE_STYLE" -l "$lexer" "$FNAME"
            } else {
                pygmentize -O style="$Env:PWSHRC_COLORIZE_STYLE" -g "$FNAME"
            }
        }
        "chroma" {
            $PWSHRC_COLORIZE_CHROMA_FORMATTER = $Env:PWSHRC_COLORIZE_CHROMA_FORMATTER ?? "terminal"
            chroma --style="$Env:PWSHRC_COLORIZE_STYLE" --formatter="$PWSHRC_COLORIZE_CHROMA_FORMATTER" "$FNAME"
        }
    }
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
