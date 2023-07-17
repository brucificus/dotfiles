#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back


# Create a directory and cd into it
mcd() {
    mkdir "${1}" && (cd "${1}" || return $?)
}

# Go up [n] directories
up()
{
    cdir="$(pwd)"
    if [ -z "$1" ]; then
        cdir="$(dirname "${cdir}")"
    elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a number"
    elif ! [ "${1}" -gt 0 ]; then
        echo "Error: argument must be positive"
    else
        for ((i=0; i<${1}; i++)); do
            ncdir="$(dirname "${cdir}")"
            if [ "${cdir}" = "${ncdir}" ]; then
                break
            else
                cdir="${ncdir}"
            fi
        done
    fi
    cd "${cdir}" || (unset cdir && return)
}

# Execute a command in a specific directory
xin() {
    (
        cd "${1}" && shift && "${@}"
    )
}

# Jump to directory containing file
jump() {
    cd "$(dirname "${1}")" || return $?
}

here() {
    loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink "$HOME/.shell.here")"
    unset loc
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")" || return $?
}

if [ -n "${BASH_VERSION}" ]; then
    shopt -s autocd
elif [ -n "${ZSH_VERSION}" ]; then
    setopt autocd
fi

if [ -n "${BASH_VERSION}" ]; then
    : # 🙁
elif [ -n "${ZSH_VERSION}" ]; then
    plugins+=(dirhistory)
fi


if command_exists zoxide; then
    # We don't use a special "plugin" for Zoxide, because eval'ing it is enough.
    eval "$(zoxide init "$(shell_actual)")"
else
    append_profile_suggestions "# TODO: ⚡ Install \`zoxide\`. See: https://github.com/ajeetdsouza/zoxide#installation."

    autojump="$(find_autojump)" || autojump=''
    if [ -n "$autojump" ]; then
        # We don't use a special "plugin" for autojump, because sourcing it is enough.
        # shellcheck disable=SC1090  # Dynamic source.
        _assert_sourced "$autojump" || source "$autojump" || return $?
        unset autojump
    elif command_exists fasd; then
        append_profile_suggestions "# TODO: ⚡ Install \`autojump\`. See: https://github.com/wting/autojump#installation."
        if [ -n "$BASH_VERSION" ]; then
            source "$BASHIT_PLUGINS_AVAILABLE"/fasd.plugin.bash
        elif [ -n "$ZSH_VERSION" ]; then
            plugins+=(fasd)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fasd
        fi

    else
        append_profile_suggestions "# TODO: ⚡ Install \`autojump\` or \`fasd\`. See: https://github.com/wting/autojump#installation or https://github.com/clvv/fasd#install."
    fi
fi
