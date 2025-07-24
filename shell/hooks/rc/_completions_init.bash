#!/usr/bin/env bash


if [ -z "$BASH_VERSION" ]; then return 0; fi


# See: https://ss64.com/bash/shopt.html

# Correct minor errors in the spelling of a directory component in a cd command.
# The errors checked for are transposed characters, a missing character,
# and a character too many.
# If a correction is found, the corrected path is printed, and the command proceeds.
shopt -s cdspell

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck disable=SC1091
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck disable=SC1091
    . /etc/bash_completion
  fi
fi
