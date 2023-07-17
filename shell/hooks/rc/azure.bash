#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists az; then
    if [ -n "$BASH_VERSION" ]; then
        : # load_bashit_xyz def
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            azure  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/azure
        )
    fi
else
    append_profile_suggestions "# TODO: ☁️ Add \`az\` to your PATH."
fi
