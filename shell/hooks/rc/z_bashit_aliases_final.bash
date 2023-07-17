#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -z "$BASH_VERSION" ]; then return 0; fi
# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


# Load after all aliases and completions to understand what needs to be completed.
source "$BASHIT_COMPLETIONS_AVAILABLE"/aliases.completion.bash
