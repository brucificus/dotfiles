#!/usr/bin/env bash


# from https://askubuntu.com/a/459425
os_release_name="$(awk -F= '/^NAME/{print $2}' /etc/os-release)"


if [[ "$os_release_name" = '"Ubuntu"' ]]; then
    unset os_release_name

    # from https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu

    # Update the list of packages
    sudo apt-get update
    # Install pre-requisite packages.
    sudo apt-get install -y wget apt-transport-https software-properties-common
    # Download the Microsoft repository GPG keys
    wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
    # Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb
    # Delete the the Microsoft repository GPG keys file
    rm packages-microsoft-prod.deb
    # Update the list of packages after we added packages.microsoft.com
    sudo apt-get update
    # Install PowerShell
    sudo apt-get install -y powershell
else
    echo "Unsupported OS: $os_release_name"
    unset os_release_name
    exit 1
fi
