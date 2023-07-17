#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi

if command_exists direnv; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/direnv.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/direnv.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            direnv  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/direnv
        )
    fi
else
    append_profile_suggestions "# TODO: ⚡ Install \`direnv\`. See: https://github.com/direnv/direnv."
fi

if [ -n "$BASH_VERSION" ]; then
    source "$BASHIT_PLUGINS_AVAILABLE"/projects.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/projects.plugin.bash
    source "$BASHIT_COMPLETIONS_AVAILABLE"/makefile.completion.bash
    source "$BASHIT_COMPLETIONS_AVAILABLE"/projects.completion.bash

    # Make Bash-It's "projects" plugin use the value of the PROJECT_PATHS variable, which pj for *Zsh* uses.
    # This has to run *after* Bash-It plugin "projects" is *sourced*, because it initializes the variable to something hard-coded.
    BASH_IT_PROJECT_PATHS="${PROJECT_PATHS}"; export BASH_IT_PROJECT_PATHS
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        jira  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jira
        jira+  # https://github.com/gerges-zz/oh-my-zsh-jira-plus
        pj  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pj
    )
fi


if [ -n "${TODO}" ] && command_exists "${TODO?}"; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/todo.plugin.bash
        source "$BASHIT_ALIASES_AVAILABLE"/todo.txt-cli.aliases.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/todo.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
fi
