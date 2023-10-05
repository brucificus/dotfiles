#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Find the Docker executable, make sure it isn't the Windows one from within WSL.

if (-not $Env:DOCKER) {
    Set-EnvVar -Process -Name DOCKER -Value (Search-CommandPath "docker")
    if (-not $Env:DOCKER) {
        if ($IsWSL) {
            if (-not (Test-Command docker.exe)) {
                append_profile_suggestions "# TODO: 🐋 Install 'Docker Desktop' on your Windows host. See: https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers."
            }
            append_profile_suggestions "# TODO: 🐋 ⬆️ *Then* install Linux-native 'docker' for this WSL-contained Linux instance. See: https://docs.docker.com/engine/install/."
        } else {
            append_profile_suggestions "# TODO: 🐋 Install 'docker'. See: https://docs.docker.com/engine/install/."
        }
        Remove-EnvVar -Process -Name DOCKER
    }
}
