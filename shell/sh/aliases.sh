# shellcheck shell=sh

# Use colors in coreutils utilities output
alias ls='ls --color=auto --almost-all --group-directories-first --human-readable -g --file-type'

# some more ls aliases
alias sl=ls
alias ll='ls -alF'
alias la='ls -AF'
alias l='ls -CF'
alias l1='ls -1'
alias lf='ls -F'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

alias cls='clear'
alias q='exit'

# Language aliases
if binary_exists ruby; then
    alias rb='ruby'
fi
if binary_exists python3; then
    alias py='python3'
fi
if binary_exists ipython3; then
    alias ipy='ipython3'
fi

alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back

# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && ./install.sh -q
    )
}

if binary_exists pip; then
    # Use pip without requiring virtualenv.
    syspip() {
        PIP_REQUIRE_VIRTUALENV="" pip "$@"
    }
fi

if binary_exists pip2; then
    # Use pip2 without requiring virtualenv.
    syspip2() {
        PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
    }
fi

if binary_exists git; then
    # cd to git root directory
    alias cdgr='cd "$(git root)"'
fi

# Create a directory and cd into it
mcd() {
    mkdir "${1}" && (cd "${1}" || return)
}

# Jump to directory containing file
jump() {
    cd "$(dirname "${1}")" || return
}

# cd replacement for screen to track cwd (like tmux)
scr_cd()
{
    builtin cd "$1" || return
    screen -X chdir "$PWD"
}

if [ -n "$STY" ]; then
    alias cd=scr_cd
fi

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

if binary_exists grep; then
    # Check if a file contains non-ascii characters
    nonascii() {
        LC_ALL=C grep -n '[^[:print:][:space:]]' "${1}"
    }
fi

if binary_exists git; then
    # Fetch pull request
    fpr() {
        if ! git rev-parse --git-dir > /dev/null 2>&1; then
            echo "error: fpr must be executed from within a git repository"
            return 1
        fi
        (
            cdgr
            if [ "$#" -eq 1 ]; then
                repo="${PWD##*/}"
                user="${1%%:*}"
                branch="${1#*:}"
            elif [ "$#" -eq 2 ]; then
                repo="${PWD##*/}"
                user="${1}"
                branch="${2}"
            elif [ "$#" -eq 3 ]; then
                repo="${1}"
                user="${2}"
                branch="${3}"
            else
                echo "Usage: fpr [repo] username branch"
                return 1
            fi

            git fetch "git@github.com:${user}/${repo}" "${branch}:${user}/${branch}"
            unset repo user branch
        )
    }
fi

if binary_exists ruby; then
    # Serve current directory
    serve() {
        ruby -run -e httpd . -p "${1:-8080}"
    }
fi

if binary_exists wget; then
    # Mirror a website
    alias mirrorsite='wget -m -k -K -E -e robots=off'
fi

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if command_exists notify-send; then
    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
