#!/usr/bin/env bash


if [ -z "$BASH_VERSION" ]; then return 2; fi


# See: https://ss64.com/bash/shopt.html

# Check that a command found in the hash table exists before trying to execute it.
shopt -s checkhash

shopt -s extglob

# Set that the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Disables mail warnings.
# Who the heck uses Linux "mail"? Not this chowder head, that's for sure.
shopt -u mailwarn


# If we're in an interactive shell,
if [[ $- == *i* ]]; then
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # Enable interactive comments (# on the command line).
    shopt -s interactive_comments
fi
