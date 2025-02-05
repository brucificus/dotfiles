#!/usr/bin/env bash
set -e


BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${BASEDIR}" &> /dev/null
# `return $ret` is important for when trapping a SIGINT:
#  The return status from the function is handled specially. If it is zero, the signal is
#  assumed to have been handled, and execution continues normally. Otherwise, the shell
#  will behave as interrupted except that the return status of the trap is retained.
#  This means that for a CTRL+C, the trap needs to return the same exit status so that
#  the shell actually exits what it's running.
trap "
    ret=\$?
    unset BASEDIR CONFIG CONFIG_WSL DOTBOT_DIR DOTBOT_BIN
    popd &> /dev/null
    # return \$ret
" EXIT INT QUIT

# Make sure dotbot is and our other dependencies are available.
git submodule update --quiet --init --force --depth 1 --recursive

# Execute dotbot.
DOTBOT_DIR="dotbot"
CONFIG="install.conf.yaml"
CONFIG_WSL="install.wsl.conf.yaml"
DOTBOT_BIN="bin/dotbot"
"${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
if [ -n "$WSL_DISTRO_NAME" ] && [ -f "$CONFIG_WSL" ]; then
    "${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG_WSL}" "${@}"
fi
