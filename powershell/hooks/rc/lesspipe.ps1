#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# make less more friendly for non-text input files, see lesspipe(1)
if (Test-Command lesspipe) {
    # TODO: Amend implementation of Read-DotEnv to support this.
    # xwith @{
    #     SHELL = "/bin/sh"
    # }, { lesspipe } `
    # | Read-DotEnv `
    # | Set-EnvVar -Process
}
