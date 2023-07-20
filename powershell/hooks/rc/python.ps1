#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[string] $ds = [System.IO.Path]::DirectorySeparatorChar
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

if ((-not (Test-Command pyenv)) -and ($Env:PYENV_ROOT) -and (Test-Path "${Env:PYENV_ROOT}${ds}bin${ds}pyenv" -ErrorAction SilentlyContinue)) {
    Add-EnvPathItem -Process -Value "${Env:PYENV_ROOT}${ds}bin"
}
if ((-not (Test-Command pyenv)) -and (Test-Path "${HOME}${ds}.pyenv${ds}bin" -ErrorAction SilentlyContinue)) {
    Add-EnvPathItem -Process -Value "${HOME}${ds}.pyenv${ds}bin"
    Set-EnvVar -Process -Name PYENV_ROOT -Value "${HOME}${ds}.pyenv"
}

if ((Test-Command pyenv) -or (Test-Command virtualenvwrapper.sh)) {
    phook_enqueue_module "poshy-wrap-pyenv"
} else {
    append_profile_suggestions "# TODO: 🐍 Install 'pyenv' See: https://github.com/pyenv/pyenv#installation."
}

if (Test-Command conda) {
    # Intentionally left blank.
} else {
    append_profile_suggestions "# TODO: 🐍 Install 'conda'. See: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html."
}

if (Test-Command pylint) {
    phook_enqueue_module "poshy-wrap-pylint"
} else {
    append_profile_suggestions "# TODO: 🐍 Install 'pylint'. See: https://pylint.org/#install."
}
