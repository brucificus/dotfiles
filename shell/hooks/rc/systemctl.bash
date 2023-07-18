#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if pidof systemd > /dev/null 2>&1; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/systemd.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            systemd  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
        )
    fi
fi
