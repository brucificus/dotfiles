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


if command_exists pg_config; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/postgres.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/postgres.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(postgres)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/postgres
    fi
else
    append_profile_suggestions "# TODO: 💽 Install PostgresSQL. See: https://www.postgresql.org/download/."
fi

