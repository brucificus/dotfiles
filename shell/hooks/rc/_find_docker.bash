#!/usr/bin/env bash


# Find the Docker executable, make sure it isn't the Windows one from within WSL.
if [ -z "$DOCKER" ]; then
    DOCKER="$(find_binary "docker")"
    case "$DOCKER" in
        "/mnt/"*)
            DOCKER=""
            ;;
    esac
    if [ -z "$DOCKER" ]; then
        if [ -n "$WSL_DISTRO_NAME" ]; then
            if ! command_exists docker.exe; then
                append_profile_suggestions "# TODO: 🐋 Install \`Docker Desktop\` on your Windows host. See: https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers."
            fi
            append_profile_suggestions "# TODO: 🐋 ⬆️ *Then* install Linux-native \`docker\` for this WSL-contained Linux instance. See: https://docs.docker.com/engine/install/."
        else
            append_profile_suggestions "# TODO: 🐋 Install \`docker\`. See: https://docs.docker.com/engine/install/."
        fi
        unset DOCKER;
    else
        export DOCKER;
    fi
fi
