#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists go; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/go.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/go.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/go.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(golang)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang
    fi
else
    append_profile_suggestions "# TODO: 🐹 Install \`go\`. See: https://go.dev/doc/install"
fi
