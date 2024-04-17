#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[string] $ds = [System.IO.Path]::DirectorySeparatorChar
if (Test-Command node) {
    # Ensure local modules are preferred in PATH
    Add-EnvPathItem -Process -Value ".${ds}node_modules${ds}.bin" -Prepend

    if (Test-Command npm) {
        # If not using nodenv, ensure global modules are in PATH
        $npmSource = (Get-Command npm).Source
        if ($npmSource -notlike "*nodenv${ds}shims*") {
            [string] $npmPrefix = (npm config get prefix)
            Add-EnvPathItem -Process -Value "${npmPrefix}${ds}bin"
            Remove-Variable -Name npmPrefix
        }
        Remove-Variable -Name npmSource
    }

    [bool] $found_nodeenv = (Test-Command nodenv)
    try {
        if (-not $found_nodeenv) {
            [string[]] $nodeenvDirs = @(
                "${HOME}${ds}.nodenv"
                "/usr/local/nodenv"
                "/opt/nodenv"
                "/usr/local/opt/nodenv"
            )
            foreach ($dir in $nodeenvDirs) {
                if (Test-Path "${dir}${ds}bin") {
                    Add-EnvPathItem -Process -Value "${dir}${ds}bin"
                    $found_nodeenv = $true
                    break
                }
            }

            if (-not $found_nodeenv) {
                if (Test-Command brew) {
                    $dir = $(brew --prefix nodenv 2> $null)
                    if (Test-Path $dir -ErrorAction SilentlyContinue) {
                        Add-EnvPathItem -Process -Value "${dir}${ds}bin"
                        $found_nodeenv = $true
                    }
                }
            }
        }
        if ($found_nodeenv) {
            #TODO: eval "$(nodenv init --no-rehash - zsh)"
        }
    }
    finally {
        Remove-Variable -Name dir -ErrorAction SilentlyContinue
        Remove-Variable -Name found_nodeenv -ErrorAction SilentlyContinue
        Remove-Variable -Name nodeenvDirs -ErrorAction SilentlyContinue
    }

    <#
    .SYNOPSIS
        Open the node api for your current version to the optional section.
    .COMPONENT
        node
    #>
    function node-docs {
        param(
            [string] $section = "all"
        )
        start "https://nodejs.org/docs/$(node --version)/api/$section.html"
    }

    function Set-NodeEnvDevelopment {
        Set-EnvVar -Process -Name NODE_ENV -Value "development"
    }
    Set-Alias -Name node-dev -Value Set-NodeEnvDevelopment

    function Set-NodeEnvProduction {
        Set-EnvVar -Process -Name NODE_ENV -Value "production"
    }
    Set-Alias -Name node-prod -Value Set-NodeEnvProduction
}
elseif (Test-Command nvm) {
    append_profile_suggestions "# TODO: 🔨 Add 'node' to your PATH. (Have you run NVM yet?)"
}

if (Test-Command npm) {
    phook_enqueue_module "poshy-wrap-npm"
}
elseif (Test-Command nvm) {
    append_profile_suggestions "# TODO: 🔨 Add 'npm' to your PATH. (Have you run NVM yet?)"
}

if (-not $Env:NVM_DIR) {
    [string] $nonbrew_nvm_location1 = "${HOME}${ds}.nvm"
    [string] $nonbrew_nvm_location2 = Join-Path -Path $Env:XDG_CONFIG_HOME -ChildPath ".config${ds}nvm"

    if (Test-Path $nonbrew_nvm_location1 -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name NVM_DIR -Value $nonbrew_nvm_location1
    }
    elseif (Test-Path $nonbrew_nvm_location2 -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name NVM_DIR -Value $nonbrew_nvm_location2
    }
    elseif (Test-Command brew) {
        Set-EnvVar -Process -Name HOMEBREW_PREFIX -Value (brew --prefix) -SkipOverwrite
        [string] $brew_nvm_location = Join-Path -Path $Env:HOMEBREW_PREFIX -ChildPath "opt${ds}nvm"
        Set-EnvVar -Process -Name NVM_HOMEBREW -Value $brew_nvm_location -SkipOverwrite
        if (Test-Path $Env:NVM_HOMEBREW) {
            Set-EnvVar -Process -Name NVM_DIR -Value $Env:NVM_HOMEBREW
        }
    }
    Remove-Variable -Name nonbrew_nvm_location1
    Remove-Variable -Name nonbrew_nvm_location2
}

Set-EnvVar -Process -Name NVM_COMPLETION -Value $true
Set-EnvVar -Process -Name NVM_LAZY_LOAD -Value $true
Set-EnvVar -Process -Name NVM_AUTO_USE -Value $true

if (Test-Command nvm) {
    # Intentionally left blank.
}
elseif (-not (Test-Command nvm)) {
    append_profile_suggestions "# TODO: 🔨 Add 'nvm' to your PATH."
}

Remove-Variable -Name ds
