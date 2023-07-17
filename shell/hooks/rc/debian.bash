#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists apt; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/apt.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            debian  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/debian
            ubuntu  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ubuntu
        )
    fi
fi
