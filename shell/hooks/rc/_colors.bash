#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -n "$BASH_VERSION" ]; then
    source "$BASHIT_PLUGINS_AVAILABLE"/colors.plugin.bash || return $?
    source "$BASHIT_PLUGINS_AVAILABLE"/man.plugin.bash || return $?
    source "$BASHIT_PLUGINS_AVAILABLE"/tmux.plugin.bash || return $?
fi
