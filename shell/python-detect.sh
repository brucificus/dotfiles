#!/usr/bin/env sh

source ~/.shell/functions.sh

# Find the python3 executable, make sure it isn't the Windows one from within WSL.
if [ -z "$PYTHON3" ]; then
    if [ -x "$WSL_DISTRO_NAME" ]; then
        windows_python_scripts_pattern='^/mnt/.*Python.*/Scripts'
        path_removematch "$windows_python_scripts_pattern"
        unset windows_python_scripts_pattern
    fi

    PYTHON3="$(command -v python3)"
    case "$PYTHON3" in
        "/mnt/"*)
            PYTHON3=""
            ;;
    esac
    if [ -z "$PYTHON3" ]; then
        return
    fi
fi
export PYTHON3

python3() {
    "$PYTHON3" "$@"
}

# Find the pip3 executable, make sure it isn't the Windows one from within WSL.
if [ -z "$PIP3" ]; then
    PIP3="$(command -v pip3)"
    case "$PIP3" in
        "/mnt/"*)
            PIP3=""
            ;;
    esac
    if [ -z "$PIP3" ]; then
        return
    fi
fi
export PIP3

pip3() {
    python3 "$PIP3" "$@"
}

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# Cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE="$HOME/.pip/cache"

# Python startup file
export PYTHONSTARTUP="$HOME/.pythonrc"

# A way to use pip without requiring a virtualenv.
syspip3() {
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}
