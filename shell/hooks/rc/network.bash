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
    source "$BASHIT_PLUGINS_AVAILABLE"/proxy.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/proxy.plugin.bash
    source "$BASHIT_PLUGINS_AVAILABLE"/ssh.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/ssh.plugin.bash
    source "$BASHIT_COMPLETIONS_AVAILABLE"/ssh.completion.bash
    if command_exists ssh-agent; then
        source "$BASHIT_PLUGINS_AVAILABLE"/sshagent.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/sshagent.plugin.bash
    fi
elif [ -n "$ZSH_VERSION" ]; then
    if command_exists nmap; then
        plugins+=(
            nmap  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nmap
        )
    fi
    if command_exists ssh-agent; then
        plugins+=(
            ssh-agent  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent
        )
    fi
    plugins+=(
        urltools  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/urltools
    )
fi
