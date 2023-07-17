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


alias cls='clear'


if [ -n "$BASH_VERSION" ]; then
    case "${TERM:-dumb}" in
        xterm* | rxvt*)
            source "$BASHIT_PLUGINS_AVAILABLE"/xterm.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/xterm.plugin.bash
            ;;
    esac
elif [ -n "$ZSH_VERSION" ]; then
    : # 🙁
fi

