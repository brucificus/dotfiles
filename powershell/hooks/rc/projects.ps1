#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-SessionInteractivity)) {
    return
}

if (Test-Command direnv) {
    function _direnv_hook {
        # TODO: Amend implementation of Read-DotEnv to support this.
        # TODO: (direnv export bash) | Read-DotEnv | Set-EnvVar -Process
        throw [System.NotImplementedException]::new()
    }
    # TODO: add-pwsh-precmd-hook _direnv_hook
    # TODO: add-pwsh-chpwd-hook _direnv_hook
} else {
    append_profile_suggestions "# TODO: ⚡ Install 'direnv'. See: https://github.com/direnv/direnv."
}

if ($Env:PROJECT_PATHS -and (Test-Command zoxide)) {
    Get-EnvVarPathItem -Process -Name PROJECT_PATHS | ForEach-Object {
        if (Test-Path $_ -ErrorAction SilentlyContinue) {
            Get-ChildItem $_ -Directory | ForEach-Object {
                zoxide add $_
            }
        }
    }
    Set-Alias -Name pj -Value z
}
