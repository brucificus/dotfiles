#!/usr/bin/env bash

if [ -n "$SETTINGS_BASH_INIT" ]; then
    return
fi
SETTINGS_BASH_INIT=1; export SETTINGS_BASH_INIT

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1048576
HISTFILE="$HOME/.bash_history"
SAVEHIST=$HISTSIZE

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
