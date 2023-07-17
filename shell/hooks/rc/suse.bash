#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists zypper; then
    if [ -n "$BASH_VERSION" ]; then
        : # load_basit_xyz def
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            suse  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/suse
        )
    fi
fi
