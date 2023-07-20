#!/usr/bin/env pwsh
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
        }
    }

    [bool] $found_nodeenv = (Test-Command nodenv)
    if (-not $found_nodeenv) {
        [string[]] $nodeenvDirs=@(
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
                $dir=$(brew --prefix nodenv 2>/dev/null)
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
} elseif (Test-Command nvm) {
    append_profile_suggestions "# TODO: 🔨 Add 'node' to your PATH. (Have you run NVM yet?)"
}

if (Test-Command npm) {
    phook_enqueue_module "poshy-wrap-npm"
} elseif (Test-Command nvm) {
    append_profile_suggestions "# TODO: 🔨 Add 'npm' to your PATH. (Have you run NVM yet?)"
}

if (-not $Env:NVM_DIR) {
    if (Test-Path "${HOME}${ds}.nvm" -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name NVM_DIR -Value "${HOME}${ds}.nvm"
    } elseif (Test-Path "${Env:XDG_CONFIG_HOME}${ds}.config${ds}nvm" -ErrorAction SilentlyContinue) {
        Set-EnvVar -Process -Name NVM_DIR -Value "${Env:XDG_CONFIG_HOME}${ds}.config${ds}nvm"
    } elseif (Test-Command brew) {
        Set-EnvVar -Process -Name HOMEBREW_PREFIX -Value (brew --prefix) -SkipOverwrite
        Set-EnvVar -Process -Name NVM_HOMEBREW -Value "${Env:HOMEBREW_PREFIX}${ds}opt${ds}nvm" -SkipOverwrite
        if (Test-Path $Env:NVM_HOMEBREW) {
            Set-EnvVar -Process -Name NVM_DIR -Value $Env:NVM_HOMEBREW
        }
    }
}

Set-EnvVar -Process -Name NVM_COMPLETION -Value $true
Set-EnvVar -Process -Name NVM_LAZY_LOAD -Value $true
Set-EnvVar -Process -Name NVM_AUTO_USE -Value $true

if (Test-Command nvm) {
    # Intentionally left blank.
} elseif (-not (Test-Command nvm)) {
    append_profile_suggestions "# TODO: 🔨 Add 'nvm' to your PATH."
}
