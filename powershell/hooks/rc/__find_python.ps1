#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


try {
    #
    # Find the python3 executable.
    #
    [string] $python3 = Search-CommandPath "python3"
    if (-not $Env:PYTHON3 -and $python3) {
        Set-EnvVar -Process -Name PYTHON3 -Value $python3
        if (-not $Env:PYTHON3) {
            append_profile_suggestions "# TODO: 🐍 Install 'python3'."
            return
        }
    }

    phook_push_module "poshy-wrap-python"

    #
    # Find the pip3 executable.
    #
    [string] $pip3 = Search-CommandPath "pip3"
    if (-not $Env:PIP3 -and $pip3) {
        Set-EnvVar -Process -Name PIP3 -Value $pip3
        if (-not $Env:PIP3) {
            append_profile_suggestions "# TODO: 🐍 Install 'pip3'."
            return
        }
    }

    # pip should only run if there is a virtualenv currently activated
    Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"

    # Cache pip-installed packages to avoid re-downloading
    Set-EnvVar -Process -Name PIP_DOWNLOAD_CACHE -Value (Join-Path $Env:XDG_CACHE_HOME "pip")

    # Python startup file
    Set-EnvVar -Process -Name PYTHONSTARTUP -Value (Join-Path $HOME ".pythonrc")


    # Backwards compat - move from the profile's old pip cache location to the new XDG-based one.
    $ds = [System.IO.Path]::DirectorySeparatorChar
    [string] $old_profile_pip_cache_location="${HOME}${ds}.pip${ds}cache"
    if ((Test-d $old_profile_pip_cache_location) -and ( -not (Test-L $old_profile_pip_cache_location) )) {
        mkdir -p $Env:PIP_DOWNLOAD_CACHE | Out-Null
        mv $old_profile_pip_cache_location/* $Env:PIP_DOWNLOAD_CACHE | Out-Null
        rmdir $old_profile_pip_cache_location | Out-Null
        ln -s $Env:PIP_DOWNLOAD_CACHE $old_profile_pip_cache_location | Out-Null
    }
} finally {
    Remove-Variable -Name ds -ErrorAction SilentlyContinue
    Remove-Variable -Name old_profile_pip_cache_location -ErrorAction SilentlyContinue
    Remove-Variable -Name pip3 -ErrorAction SilentlyContinue
    Remove-Variable -Name python3 -ErrorAction SilentlyContinue
}
