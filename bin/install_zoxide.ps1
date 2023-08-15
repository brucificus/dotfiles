#!/usr/bin/env pwsh

# https://github.com/ajeetdsouza/zoxide#installation



if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Write-Warning "zoxide is already installed."
    return
}

if ($IsWindows) {
    $installer_commands = @(
        @{ command = "choco";           install = "choco install zoxide" }
        @{ command = "winget";          install = "winget install zoxide" }
        @{ command = "scoop";           install = "scoop install zoxide" }
    )

    foreach ($installer_command in $installer_commands) {
        if (Get-Command $installer_command.command -ErrorAction SilentlyContinue) {
            Invoke-Expression $installer_command.install
            return
        }
    }

    if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
        Write-Warning "Please install winget, choco or scoop first."
        return
    }
} else {
    $installer_commands = @(
        @{ command = "apk";             install = "sudo apk add zoxide" }
        @{ command = "apt";             install = "sudo apt install zoxide" }
        @{ command = "conda";           install = "conda install -c conda-forge zoxide" }
        @{ command = "dnf";             install = "sudo dnf install zoxide" }
        @{ command = "nix-env";         install = "nix-env -iA nixpkgs.zoxide" }
        @{ command = "pacman";          install = "sudo pacman -S zoxide" }
        @{ command = "xbps-install";    install = "sudo xbps-install -S zoxide" }
        @{ command = "brew";            install = "brew install zoxide" }
    )

    foreach ($installer_command in $installer_commands) {
        if (Get-Command $installer_command.command -ErrorAction SilentlyContinue) {
            Invoke-Expression $installer_command.install
            return
        }
    }

    if (-not (Get-Command zoxide -ErrorAction SilentlyContinue)) {
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    }
}
