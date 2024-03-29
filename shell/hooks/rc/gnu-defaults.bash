#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if [ -z "$BASH_VERSION" ]; then return 0; fi
# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


_assert_sourced "${BASH_IT?}/vendor/github.com/gaelicWizard/bash-progcomp/defaults.completion.bash" || source "${BASH_IT?}/vendor/github.com/gaelicWizard/bash-progcomp/defaults.completion.bash" || return $?
