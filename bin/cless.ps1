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


# The less option 'F - Forward forever; like "tail -f".' will not work in this implementation
# caused by the lack of the ability to follow the file within pygmentize.

function _cless {
    param(
        [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
        [string[]] $rest = $null,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline)]
        [object] $InputObject = $null
    )
    # # TODO: source envvar helpers.
    # . "$PSScriptRoot/../powershell/funcs/x/xwith.ps1"

    # # LESS="-R $LESS" enables raw ANSI colors, while maintain already set options.
    # $Env:LESS="-R $Env:LESS"


    # # This variable tells less to pipe every file through the specified command
    # # (see the man page of less INPUT PREPROCESSOR).
    # # 'zsh -ic "colorize_cat %s 2> /dev/null"' would not work for huge files like
    # # the ~/.zsh_history. For such files the tty of the preprocessor will be suspended.
    # # Therefore we must source this file to make colorize_cat available in the
    # # preprocessor without the interactive mode.
    # # `2>/dev/null` will suppress the error for large files 'broken pipe' of the python
    # # script pygmentize, which will show up if less has not fully "loaded the file"
    # # (e.g. when not scrolled to the bottom) while already the next file will be displayed.
    # local LESSOPEN="| pwsh -c 'source \"$Env:PWSHRC_COLORIZE_PLUGIN_PATH\"; \
    # PWSHRC_COLORIZE_TOOL=$Env:PWSHRC_COLORIZE_TOOL PWSHRC_COLORIZE_STYLE=$Env:PWSHRC_COLORIZE_STYLE \
    # colorize_cat %s 2> /dev/null'"

    # # LESSCLOSE will be set to prevent any errors by executing a user script
    # # which assumes that his LESSOPEN has been executed.
    # local LESSCLOSE=""

    # LESS="$LESS" LESSOPEN="$LESSOPEN" LESSCLOSE="$LESSCLOSE" command less "$@"

    $InputObject | less @rest
}


if ($null -ne $Host.UI.RawUI.BufferSize) {
    $InputObject | _cless @rest
} else {
    # The input is not associated with a terminal, therefore colorize_cat will
    # colorize this input and pass it to less.
    # Less has now to decide what to use. If any files have been provided, less
    # will ignore the input by default, otherwise the colorized input will be used.
    # If files have been supplied and the input has been redirected, this will
    # lead to unnecessary overhead, but retains the ability to use the less options
    # without checking for them inside this script.
    $InputObject | ccat.ps1 | _cless "$@"
}
