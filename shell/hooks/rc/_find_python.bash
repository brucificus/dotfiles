#!/usr/bin/env bash


if command_exists "python" || command_exists "conda"; then
    if [ -e "$HOME/.pythonrc" ]; then
        PYTHONSTARTUP="$HOME/.pythonrc"; export PYTHONSTARTUP
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install 'python'."
    return
fi


if command_exists "pip"; then
    # Python startup file
    if [ -e "$HOME/.pythonrc" ]; then
        PYTHONSTARTUP="$HOME/.pythonrc"; export PYTHONSTARTUP
    fi

    # pip should only run if there is a virtualenv currently activated
    export PIP_REQUIRE_VIRTUALENV=true

    # Cache pip-installed packages to avoid re-downloading
    export PIP_DOWNLOAD_CACHE="${XDG_CACHE_HOME:?}/pip"

    # Backwards compat - move from the profile's old pip cache location to the new XDG-based one.
    old_profile_pip_cache_location="$HOME/.pip/cache"
    if [ -d "$old_profile_pip_cache_location" ] && [ ! -L "$old_profile_pip_cache_location" ]; then
        mkdir -p "$PIP_DOWNLOAD_CACHE" > /dev/null 2>&1 || return 1
        mv "$old_profile_pip_cache_location"/* "$PIP_DOWNLOAD_CACHE" > /dev/null 2>&1 || return 1
        rmdir "$old_profile_pip_cache_location" > /dev/null 2>&1 || return 1
        ln -s "$PIP_DOWNLOAD_CACHE" "$old_profile_pip_cache_location" > /dev/null 2>&1 || return 1
    fi
    unset old_profile_pip_cache_location
else
    append_profile_suggestions "# TODO: 🐍 Install 'pip'."
fi
