#!/usr/bin/env zsh

# Initialize completion
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '~/.zshrc'

# Initialize editing command line
autoload -Uz compinit

compinit

# Enable interactive comments (# on the command line)
setopt interactivecomments

# Nicer history
HISTSIZE=1048576
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt incappendhistory
setopt extendedhistory
setopt autocd extendedglob

# Use vim as the editor
export EDITOR=nano
