#!/usr/bin/env bash


BASH_IT="$(realpath "$PWD"/../../vendor/bash-it)"; export BASH_IT

BASHIT_ALIASES_AVAILABLE="$BASH_IT/aliases/available"; export BASHIT_ALIASES_AVAILABLE
BASHIT_COMPLETIONS_AVAILABLE="$BASH_IT/completion/available"; export BASHIT_COMPLETIONS_AVAILABLE
BASHIT_PLUGINS_AVAILABLE="$BASH_IT/plugins/available"; export BASHIT_PLUGINS_AVAILABLE

if [ -z "$BASH_VERSION" ]; then
    return 0
fi

# Initialize global variables for Bash-It.
BASH_IT_LOG_PREFIX="core: main: "
: "${BASH_IT:=${BASH_SOURCE%/*}}"
: "${BASH_IT_CUSTOM:=${BASH_IT}/custom}"
: "${CUSTOM_THEME_DIR:="${BASH_IT_CUSTOM}/themes"}"
: "${BASH_IT_BASHRC:=${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}}"
# Declare Bash-It's end-of-main finishing hook, but don't use `declare`/`typeset`
_bash_it_library_finalize_hook=(); export _bash_it_library_finalize_hook
export BASH_IT BASH_IT_CUSTOM CUSTOM_THEME_DIR BASH_IT_BASHRC BASH_IT_LOG_PREFIX
