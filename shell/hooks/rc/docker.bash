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


if command_exists docker; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/docker.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/docker.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/docker.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/docker.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(docker)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
    fi
else
    append_profile_suggestions "# TODO: 🐋 Install \`docker\`. See: https://docs.docker.com/desktop/install/linux-install/."
fi
