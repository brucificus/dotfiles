#!/usr/bin/env zsh


# Load dependencies.
# ZSH has been setup to autoload our functions, so it doesn't need to do anything special here.


# Loads Oh-My-Zsh if it exists.
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    if _register_sourced "$ZSH/oh-my-zsh.sh"; then
        zsh-defer source "$ZSH/oh-my-zsh.sh"
    fi
fi
