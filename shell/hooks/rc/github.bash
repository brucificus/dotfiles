#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists git; then
    alias fpr='gh_fetch_pr'
fi

if command_exists gh; then
    alias fpr='gh_fetch_pr'
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/github-cli.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            gh  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh
        )
    fi
else
    append_profile_suggestions "# TODO: 🐱 Install \`gh\`. See: https://github.com/cli/cli#installation."
fi
