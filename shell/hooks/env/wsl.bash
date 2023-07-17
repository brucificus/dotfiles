#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -z "$WSL_DISTRO_NAME" ]; then return 0; fi

# If we're in WSL, we need to do some specific PATH patching.
windows_python_scripts_pattern='^/mnt/.*Python.*/Scripts'
path_removematch "$windows_python_scripts_pattern"; export PATH
unset windows_python_scripts_pattern


WINDOWS_USER="$(cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')"; export WINDOWS_USER
WINDOWS_HOME="$(wslpath -u "$(cmd.exe /c echo %USERPROFILE% 2>/dev/null | tr -d '\r')")"; export WINDOWS_HOME
