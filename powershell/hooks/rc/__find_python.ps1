#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if ((Test-Command python) -or (Test-Command conda)) {
    [string] $pythonStartup = (Join-Path $HOME ".pythonrc")
    if (Test-Path $pythonStartup -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name PYTHONSTARTUP -Value $pythonStartup
    }
} else {
    append_profile_suggestions "# TODO: 🐍 Install 'python'."
    return
}

if (Test-Command pip) {
    # pip should only run if there is a virtualenv currently activated
    Set-EnvVar -Process -Name PIP_REQUIRE_VIRTUALENV -Value "true"

    # Cache pip-installed packages to avoid re-downloading
    Set-EnvVar -Process -Name PIP_DOWNLOAD_CACHE -Value (Join-Path $Env:XDG_CACHE_HOME "pip")

    try {
        # Backwards compat - move from the profile's old pip cache location to the new XDG-based one.
        $ds = [System.IO.Path]::DirectorySeparatorChar
        [string] $old_pip_download_cache="${HOME}${ds}.pip${ds}cache"
        if ((Test-d $old_pip_download_cache) -and ( -not (Test-L $old_pip_download_cache) )) {
            mkdir -p $Env:PIP_DOWNLOAD_CACHE | Out-Null
            mv $old_pip_download_cache/* $Env:PIP_DOWNLOAD_CACHE | Out-Null
            rmdir $old_pip_download_cache | Out-Null
            ln -s $Env:PIP_DOWNLOAD_CACHE $old_pip_download_cache | Out-Null
        }
    } finally {
        Remove-Variable -Name ds -ErrorAction SilentlyContinue
        Remove-Variable -Name old_pip_download_cache -ErrorAction SilentlyContinue
    }
} else {
    append_profile_suggestions "# TODO: 🐍 Install 'pip'."
}
