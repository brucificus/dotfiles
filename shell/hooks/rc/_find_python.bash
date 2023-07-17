#!/usr/bin/env bash


#
# Find the python3 executable, make sure it isn't the Windows one from within WSL.
#
if [ -z "$PYTHON3" ]; then
    PYTHON3="$(find_binary "python3")"
    case "$PYTHON3" in
        "/mnt/"*)
            PYTHON3=""
            ;;
    esac
    if [ -z "$PYTHON3" ]; then
        append_profile_suggestions "# TODO: 🐍 Add \`python3\` to your PATH."
        return 0
    fi
fi
export PYTHON3


#
# Find the pip3 executable, make sure it isn't the Windows one from within WSL.
#
if [ -z "$PIP3" ]; then
    PIP3="$(find_binary "pip3")"
    case "$PIP3" in
        "/mnt/"*)
            PIP3=""
            ;;
    esac
    if [ -z "$PIP3" ]; then
        append_profile_suggestions "# TODO: 🐍 Add \`pip3\` to your PATH."
        return 0
    fi
fi
export PIP3


# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# Cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE="${XDG_CACHE_HOME:?}/pip"

# Python startup file
export PYTHONSTARTUP="$HOME/.pythonrc"


# Backwards compat - move from the profile's old pip cache location to the new XDG-based one.
old_profile_pip_cache_location="$HOME/.pip/cache"
if [ -d "$old_profile_pip_cache_location" ] && [ ! -L "$old_profile_pip_cache_location" ]; then
    mkdir -p "$PIP_DOWNLOAD_CACHE" > /dev/null 2>&1 || return 1
    mv "$old_profile_pip_cache_location"/* "$PIP_DOWNLOAD_CACHE" > /dev/null 2>&1 || return 1
    rmdir "$old_profile_pip_cache_location" > /dev/null 2>&1 || return 1
    ln -s "$PIP_DOWNLOAD_CACHE" "$old_profile_pip_cache_location" > /dev/null 2>&1 || return 1
fi
