#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


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
elif command_exists git; then
    append_profile_suggestions "# TODO: 🐱 Install \`gh\`. See: https://github.com/cli/cli#installation."
fi
