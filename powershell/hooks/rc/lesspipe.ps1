#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
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
