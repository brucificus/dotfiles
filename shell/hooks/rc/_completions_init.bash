#!/usr/bin/env bash


if [ -z "$BASH_VERSION" ]; then return 0; fi


# See: https://ss64.com/bash/shopt.html

# Correct minor errors in the spelling of a directory component in a cd command.
# The errors checked for are transposed characters, a missing character, 
# and a character too many. 
# If a correction is found, the corrected path is printed, and the command proceeds.
shopt -s cdspell
