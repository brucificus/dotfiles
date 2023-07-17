#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists docker-compose; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/docker-compose.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/docker-compose.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/docker-compose.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/docker-compose.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(docker-compose)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose
    fi
else
    append_profile_suggestions "# TODO: 💡 Add \`docker-compose\` to your PATH."
fi
