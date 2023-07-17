#!/usr/bin/env bash


if [ -z "$BASH_VERSION" ]; then return 2; fi
# See: https://ss64.com/bash/shopt.html


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1048576; export HISTSIZE
HISTFILE="$HOME/.bash_history"; export HISTFILE
SAVEHIST=$HISTSIZE; export SAVEHIST

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth; export HISTCONTROL

# Append to the history file, don't overwrite it
shopt -s histappend

# Save all lines of a multiple-line command in the same history entry.
shopt -s cmdhist

shopt -s lithist
