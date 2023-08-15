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


alias dfu='dotfiles_update'
alias q='exit'


if [ -n "$WSL_DISTRO_NAME" ]; then
    if command_exists wsl-notify-send.exe; then
        alias notify-send="wsl-notify-send.exe --category \"$WSL_DISTRO_NAME\""
    else
        append_profile_suggestions "# TODO: 🛎️ Add \`wsl-notify-send\` to your path. See: https://github.com/stuartleeks/wsl-notify-send."
    fi
fi

if command_exists notify-send; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/cmd-returned-notify.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/cmd-returned-notify.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/notify-send.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        if command_exists bc; then
            plugins+=(
                wsl-notify-zsh  # https://github.com/masonc15/wsl-notify-zsh
            )
        else
            append_profile_suggestions "# TODO: 🛎️ Install \`bc\`. See: https://ss64.com/bash/bc.html."
        fi
    fi
elif [ -z "$WSL_DISTRO_NAME" ]; then
    append_profile_suggestions "# TODO: 🛎️ Install \`notify-send\`. See: https://ss64.com/bash/notify-send.html."
fi

if [ -n "$BASH_VERSION" ]; then
    shopt -s checkjobs
elif [ -n "$ZSH_VERSION" ]; then
    setopt notify
fi

if ! command_exists btop; then
    append_profile_suggestions "# TODO: 📊 Install \`btop\`. See: https://github.com/aristocratos/btop#installation."
fi
