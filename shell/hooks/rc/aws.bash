#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


if command_exists aws; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/aws.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/aws.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/awscli.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            aws  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aws
        )
    fi
elif command_exists terraform || command_exists packer; then
    append_profile_suggestions "# TODO: ☁️ Install the AWS CLI. See: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html."
fi
