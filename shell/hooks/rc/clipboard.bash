#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


if command_exists xclip; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/clipboard.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # Intentionally left blank.
    fi
else
    append_profile_suggestions "# TODO: 💡 Install \`xclip\`."
fi

if [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        copybuffer  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copybuffer
        copyfile  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copyfile
        copypath  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copypath
    )
fi
