#!/usr/bin/env pwsh

# https://github.com/junegunn/fzf#installation



if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Write-Warning "fzf is already installed."
    return
}

if ($IsWindows) {
    $installer_commands = @(
        @{ command = "winget";          install = "winget install fzf" }
        @{ command = "choco";           install = "choco install fzf" }
        @{ command = "scoop";           install = "scoop install fzf" }
    )

    foreach ($installer_command in $installer_commands) {
        if (Get-Command $installer_command.command -ErrorAction SilentlyContinue) {
            Invoke-Expression $installer_command.install
            return
        }
    }

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Warning "Please install winget, choco or scoop first."
        return
    }
} else {
    $installer_commands = @(
        @{ command = "apk";             install = "sudo apk add fzf" }
        @{ command = "apt";             install = "sudo apt install fzf" }
        @{ command = "conda";           install = "conda install -c conda-forge fzf" }
        @{ command = "dnf";             install = "sudo dnf install fzf" }
        @{ command = "nix-env";         install = "nix-env -iA nixpkgs.fzf" }
        @{ command = "pacman";          install = "sudo pacman -S fzf" }
        @{ command = "pkg";             install = "pkg install fzf" }
        @{ command = "pkgin";           install = "pkgin install fzf" }
        @{ command = "pkg_add";         install = "pkg_add fzf" }
        @{ command = "emerge";          install = "emerge --ask app-shells/fzf" }
        @{ command = "xbps-install";    install = "sudo xbps-install -S fzf" }
        @{ command = "zypper";          install = "sudo zypper install fzf" }
        @{ command = "brew";            install = "brew install fzf" }
    )

    foreach ($installer_command in $installer_commands) {
        if (Get-Command $installer_command.command -ErrorAction SilentlyContinue) {
            Invoke-Expression $installer_command.install
            return
        }
    }

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Warning "Please install one of the following: apk, apt, conda, dnf, nix-env, pacman, pkg, pkgin, pkg_add, emerge, xbps-install, zypper or brew."
    }
}
