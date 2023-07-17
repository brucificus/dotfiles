#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists xclip; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/clipboard.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # Intentionally left blank.
    fi
else
    append_profile_suggestions "# TODO: 💡 Add \`xclip\` to your PATH."
fi

if [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        copybuffer  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copybuffer
        copyfile  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copyfile
        copypath  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copypath
    )
fi
