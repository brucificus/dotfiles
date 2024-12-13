#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


try {
    if (Test-Command "python3" -ExecutableOnly) {
        phook_enqueue_module "poshy-wrap-python"
    }

    if (Test-Command "pip3" -ExecutableOnly) {
        phook_enqueue_module "poshy-wrap-pip"
    }

    if (Test-Command pipenv) {
        phook_enqueue_module "poshy-wrap-pipenv"
    } else {
        append_profile_suggestions "# TODO: 🐍 Install 'pipenv'. See: https://github.com/pypa/pipenv#installation."
    }

    [string] $ds = [System.IO.Path]::DirectorySeparatorChar
    if ((-not (Test-Command pyenv)) -and $Env:PYENV_ROOT) {
        [string] $pyenv_bin = Join-Path $Env:PYENV_ROOT "bin${ds}pyenv"
        if (Test-Path $pyenv_bin -ErrorAction SilentlyContinue) {
            Add-EnvPathItem -Process -Value $pyenv_bin
        }
    }
    [string] $pyenv_bin_dir = "${HOME}${ds}.pyenv${ds}bin"
    if ((-not (Test-Command pyenv)) -and (Test-Path $pyenv_bin_dir -ErrorAction SilentlyContinue)) {
        Add-EnvPathItem -Process -Value $pyenv_bin_dir
        Set-EnvVar -Process -Name PYENV_ROOT -Value "${HOME}${ds}.pyenv"
    }

    if ((Test-Command pyenv) -or (Test-Command virtualenvwrapper.sh)) {
        phook_enqueue_module "poshy-wrap-pyenv"
    } else {
        append_profile_suggestions "# TODO: 🐍 Install 'pyenv' See: https://github.com/pyenv/pyenv#installation."
    }

    # TODO: Fix: spuriously spits out `False` at the beginning of each newly printed prompt.
    # if (-not (Test-Command conda) -and (Test-Path "${HOME}${ds}miniconda3${ds}shell${ds}condabin${ds}conda-hook.ps1" -ErrorAction SilentlyContinue)) {
    #     phook_enqueue_file "${HOME}${ds}miniconda3${ds}shell${ds}condabin${ds}conda-hook.ps1"
    # } else {
    #     append_profile_suggestions "# TODO: 🐍 Install 'conda'. Run: ~/.dotfiles/bin/Install-Miniconda3.ps1"
    # }

    if (Test-Command uv) {
        # Intentionally left blank.
    } else {
        append_profile_suggestions "# TODO: 🐍 Install 'uv'. Run: ~/.dotfiles/bin/Install-uv.ps1"
    }

    if (Test-Command pylint) {
        phook_enqueue_module "poshy-wrap-pylint"
    } else {
        append_profile_suggestions "# TODO: 🐍 Install 'pylint'. See: https://pylint.org/#install."
    }
} finally {
    Remove-Variable -Name ds -ErrorAction SilentlyContinue
    Remove-Variable -Name pyenv_bin_dir -ErrorAction SilentlyContinue
}
