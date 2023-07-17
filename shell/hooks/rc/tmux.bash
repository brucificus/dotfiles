#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists tmux; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/tmux.aliases.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/tmux.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            tmux  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux
            tmuxinator  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmuxinator
        )
    fi
else
    append_profile_suggestions "# TODO: ⚡ Add \`tmux\` to your PATH."
fi
