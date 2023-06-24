# shellcheck shell=sh

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
SetPoshPromptPortably() {
    if command -v oh-my-posh &> /dev/null
    then
        poshshell="$(oh-my-posh get shell)"
        eval "$(oh-my-posh init "${poshshell}" --config "${1}")"
    fi
}
