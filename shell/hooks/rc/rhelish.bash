#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists yum; then
    if [ -n "$BASH_VERSION" ]; then
        : # load_basit_xyz def
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            yum  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/yum
        )
    fi
fi

if command_exists dnf; then
    if [ -n "$BASH_VERSION" ]; then
        : # load_basit_xyz def
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            dnf  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf
        )
    fi
fi
