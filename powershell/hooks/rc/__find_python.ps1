#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


$ds = [System.IO.Path]::DirectorySeparatorChar

#
# Find the python3 executable.
#
if (-not $Env:PYTHON3) {
    Set-EnvVar -Process -Name PYTHON3 -Value (Search-CommandPath "python3")
    if (-not $Env:PYTHON3) {
        append_profile_suggestions "# TODO: 🐍 Install 'python3'."
        return
    }
}

phook_push_module "poshy-wrap-python"

#
# Find the pip3 executable.
#
if (-not $Env:PIP3) {
    Set-EnvVar -Process -Name PIP3 -Value (Search-CommandPath "pip3")
    if (-not $Env:PIP3) {
        append_profile_suggestions "# TODO: 🐍 Install 'pip3'."
        return
    }
}


# pip should only run if there is a virtualenv currently activated
Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"

# Cache pip-installed packages to avoid re-downloading
Set-EnvVar -Process -Name PIP_DOWNLOAD_CACHE -Value "${Env:XDG_CACHE_HOME}${ds}pip"

# Python startup file
Set-EnvVar -Process -Name PYTHONSTARTUP -Value (Join-Path $HOME ".pythonrc")


# Backwards compat - move from the profile's old pip cache location to the new XDG-based one.
[string] $old_profile_pip_cache_location="${HOME}${ds}.pip${ds}cache"
if ((Test-d $old_profile_pip_cache_location) -and ( -not (Test-L $old_profile_pip_cache_location) )) {
    mkdir -p $Env:PIP_DOWNLOAD_CACHE | Out-Null
    mv $old_profile_pip_cache_location/* $Env:PIP_DOWNLOAD_CACHE | Out-Null
    rmdir $old_profile_pip_cache_location | Out-Null
    ln -s $Env:PIP_DOWNLOAD_CACHE $old_profile_pip_cache_location | Out-Null
}
