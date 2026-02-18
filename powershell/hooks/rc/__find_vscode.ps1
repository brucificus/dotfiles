#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Credit:
#  - Oh-My-Zsh's vscode.plugin.zsh, see: https://github.com/ohmyzsh/ohmyzsh/blob/71f0189ed57911360b19883cb6211fe621292086/plugins/vscode/vscode.plugin.zsh


# Verify if any manual user choice of VS Code exists first.
if ($Env:VSCODE -and (-not (Test-Command $Env:VSCODE))) {
    Write-Verbose "'$Env:VSCODE' flavour of VS Code not found."
    Remove-EnvVar -Process -Name VSCODE
    return
}

# Otherwise, try to detect a flavour of VS Code.
if (-not $Env:VSCODE) {
    if (Test-Command code) {
        Set-EnvVar -Process -Name VSCODE -Value code
    }
    elseif (Test-Command code-insiders) {
        Set-EnvVar -Process -Name VSCODE -Value code-insiders
    }
    elseif (Test-Command codium) {
        Set-EnvVar -Process -Name VSCODE -Value codium
    }
    elseif (Test-Command codium-insiders) {
        Set-EnvVar -Process -Name VSCODE -Value codium-insiders
    }
    else {
        append_profile_suggestions "# TODO: 👨‍💻 Install VSCode. See: https://code.visualstudio.com/Download"
        return
    }
}

phook_enqueue_module "poshy-wrap-vscode"

if (-not (Test-SessionInteractivity)) {
    return
}

# Check if the VS Code shell integration is already loaded.
if (Test-Path variable:global:__VSCodeOriginalPrompt) {
    Write-Verbose "__find_vscode.ps1: VS Code shell integration already loaded."
	return;
} elseif ($env:TERM_PROGRAM -eq "vscode") {
    try {
        [string] $vscode_integration_path = ""
        try {
            $vscode_integration_path = "$(&$Env:VSCODE --locate-shell-integration-path pwsh)"
        } catch {
            Write-Warning "__find_vscode.ps1: Failed to locate VS Code shell integration script: $_"
            return
        }
        if (-not $vscode_integration_path) {
            Write-Warning "__find_vscode.ps1: VS Code didn't return anything when asked to locate its shell integration script, exited with code '$LASTEXITCODE'."
            return
        }
    }
    finally {
        Remove-Variable -Name vscode_integration_path
    }
}
