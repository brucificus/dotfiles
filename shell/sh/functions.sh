# shellcheck shell=sh

# Checks for existence of a command.
command_exists() {
    if [ -n "$BASH_VERSION" ]; then
        if type -t "$1" > /dev/null; then
            return 0
        else
            return 1
        fi
    elif [ -n "$ZSH_VERSION" ]; then
        if whence -w "$1" > /dev/null; then
            return 0
        else
            return 1
        fi
    else
        echo "Unknown shell" >&2
        return 1
    fi
}

# Checks for existence of a binary.
binary_exists() {
    if [ -n "$BASH_VERSION" ]; then
        if type -P "$1" > /dev/null; then
            return 0
        else
            return 1
        fi
    elif [ -n "$ZSH_VERSION" ]; then
        if whence -p "$1" > /dev/null; then
            return 0
        else
            return 1
        fi
    else
        echo "Unknown shell" >&2
        return 1
    fi
}

# Checks for existence of registration of a completion for the given command.
completion_exists() {
    if [ -n "$BASH_VERSION" ]; then
        if complete -p "$1" &> /dev/null; then
            return 0
        else
            return 1
        fi
    elif [ -n "$ZSH_VERSION" ]; then
        if compctl -p "$1" &> /dev/null; then
            return 0
        else
            return 1
        fi
    else
        echo "Unknown shell" >&2
        return 1
    fi
}

naive_shell_replace() {
    printf "%s" "${1//$2/$3}"
}

# Removes $1 from $PATH.
path_remove() {
    PATH=$(printf '%s' "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

# Removes matches of $1 from $PATH.
path_removematch() {
    PATH=$(printf '%s' "$PATH" | sed 's/:/\n/g' | grep -v "$1" | sed ':a; N; $!ba; s/\n/:/g')
}

# Concatenates $1 to the end of $PATH, removing it from elsewhere in $PATH if it exists already.
path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

# Concatenates $1 to the beginning of $PATH, removing it from elsewhere in $PATH if it exists already.
path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink "$HOME/.shell.here")"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")" || return
}

# Initializes the oh-my-posh prompt to the profile $1 for the current shell.
load_ohmyposh_theme() {
    if command -v oh-my-posh &> /dev/null
    then
        poshshell="$(oh-my-posh get shell)"
        eval "$(oh-my-posh init "${poshshell}" --config "${1}")"
    fi
}
