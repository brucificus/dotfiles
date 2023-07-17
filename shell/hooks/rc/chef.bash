#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


if ! command_exists knife || ! command_exists chef || ! command_exists chef-client; then
    append_profile_suggestions "# TODO: 🧑‍🍳 Install \`chef\`. See: https://docs.chef.io/install_omnibus."
fi

if command_exists knife; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/knife.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            knife  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/knife
            knife_ssh  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/knife_ssh
        )
    fi
fi

if command_exists kitchen; then
    if [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            kitchen  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kitchen
        )
    fi
fi
