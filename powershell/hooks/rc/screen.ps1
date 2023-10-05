#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#   - Oh-My-Zsh's screen.plugin.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/f4dc8c5be365668810783ced01a86ff8f251bfd7/plugins/screen/screen.plugin.zsh



if (-not (Test-Command screen)) {
    append_profile_suggestions "# TODO: ⚡ Install 'screen'."
}

if (-not (Test-SessionInteractivity)) {
    return
}


# cd replacement for screen to track cwd (like tmux)
function scr_cd()
{
    builtin cd $1
    screen -X chdir $PWD
}

if ($Env:STY) {
    Set-Alias -Name cd -Value scr_cd
}

if ($Env:TERM -like "screen*") {
    if (-not $Env:_GET_PATH) {
        Set-EnvVar -Process -Name _GET_PATH -Value 'echo $PWD | sed "s/^\/Users\//~/;s/^\/home\//~/;s/^~$USERNAME/~/"'
    }
    if (-not $Env:_GET_HOST) {
        Set-EnvVar -Process -Name _GET_HOST -Value 'echo $HOST | sed "s/\..*//"'
    }

    # use the current user as the prefix of the current tab title
    Set-EnvVar -Process -Name TAB_TITLE_PREFIX -Value '"$($_GET_HOST):$($_GET_PATH | sed "s:..*/::")$PROMPT_CHAR"'
    # when at the shell prompt, show a truncated version of the current path (with
    # standard ~ replacement) as the rest of the title.
    Set-EnvVar -Process -Name TAB_TITLE_PROMPT -Value '$SHELL:t'
    # when running a command, show the title of the command as the rest of the
    # title (truncate to drop the path to the command)
    Set-EnvVar -Process -Name TAB_TITLE_EXEC -Value '$cmd[1]:t'

    # use the current path (with standard ~ replacement) in square brackets as the
    # prefix of the tab window hardstatus.
    Set-EnvVar -Process -Name TAB_HARDSTATUS_PREFIX -Value '"[$($_GET_PATH)] "'
    # when at the shell prompt, use the shell name (truncated to remove the path to
    # the shell) as the rest of the title
    Set-EnvVar -Process -Name TAB_HARDSTATUS_PROMPT -Value '$SHELL:t'
    # when running a command, show the command name and arguments as the rest of
    # the title
    Set-EnvVar -Process -Name TAB_HARDSTATUS_EXEC -Value '$cmd'
}
