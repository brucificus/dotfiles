#!/usr/bin/env bash


if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
else
    echo "install_pwsh: ERROR: Cannot determine OS, ``/etc/os-release`` not found." >&2
    exit 1
fi

if [ "$USER" != "root" ]
then
    echo "install_pwsh: WARNING: This script must be run as root." >&2
fi

if [[ "$NAME" = "Debian GNU/Linux" ]] || [[ "$NAME" = "Ubuntu" ]]; then
    # from https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian
    # from https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu

    # Update the list of packages
    apt-get update

    if [[ "$NAME" = "Ubuntu" ]]; then
        # Install pre-requisite packages.
        apt-get install -y wget apt-transport-https software-properties-common
    else
        # Install pre-requisite packages.
        apt-get install -y wget
    fi

    # Download the Microsoft repository keys.
    DEB_FILE="packages-microsoft-prod.deb"
    DEB_URL=""
    if [[ "$NAME" = "Ubuntu" ]]; then
        DEB_URL="https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/${DEB_FILE}"
    else
        DEB_URL="https://packages.microsoft.com/config/debian/${VERSION_ID}/${DEB_FILE}"
    fi
    if ! wget -q "$DEB_URL"; then
        echo "install_pwsh: ERROR: Failed to download $DEB_URL, wget exited with $?." >&2
        exit 1
    fi

    # Register the Microsoft repository keys.
    dpkg -i "$DEB_FILE"

    # Delete the the Microsoft repository keys file.
    rm "$DEB_FILE"

    # Update the list of packages after we added packages.microsoft.com.
    apt-get update

    # Install PowerShell.
    apt-get install -y powershell
else
    echo "install_pwsh: ERROR: Unsupported OS: $NAME" >&2
    exit 1
fi
