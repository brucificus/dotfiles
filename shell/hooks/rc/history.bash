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


if [ -n "$BASH_VERSION" ]; then
    source "$BASHIT_PLUGINS_AVAILABLE"/history-substring-search.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/history-substring-search.plugin.bash
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        history  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history
        history-substring-search  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history-substring-search
    )
fi
