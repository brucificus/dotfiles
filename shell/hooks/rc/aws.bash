#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists aws; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/aws.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/aws.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/awscli.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            aws  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aws
        )
    fi
else
    append_profile_suggestions "# TODO: ☁️ Add \`aws\` to your PATH."
fi
