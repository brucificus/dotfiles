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
        append_profile_suggestions "# TODO: 🐋 Add \`docker\` to your PATH."
        unset DOCKER;
    else
        export DOCKER;
    fi
fi
