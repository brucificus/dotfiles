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


if command_exists hub; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/hub.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            github  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/github
        )
    fi
elif command_exists git; then
    append_profile_suggestions "# TODO: 🐙 Install \`hub\`. See: https://github.com/mislav/hub#installation."
fi
