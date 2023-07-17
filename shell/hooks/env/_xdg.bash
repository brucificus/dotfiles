#!/usr/bin/env bash


# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html


# Defines the base directory relative to which user-specific data files should be stored.
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"; export XDG_DATA_HOME


# Defines the base directory relative to which user-specific configuration files should 
# be stored.
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"; export XDG_CONFIG_HOME
# This directory gets a lot of use by Bash-It and Oh-My-Zsh stuff (and problably other 
# tools/frameworks too), and not usually in a way that references $XDG_CONFIG_HOME.
# So think hard before changing the value of this variable, because those tools will
# still be writing to this directory directly.


# Defines the base directory relative to which user-specific state files should be stored.
# Contains state data that should persist between (application) restarts, but that is not 
# important or portable enough to the user that it should be stored in $XDG_DATA_HOME
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"; export XDG_STATE_HOME


# Defines the preference-ordered set of base directories to search for data files in addition
# to the $XDG_DATA_HOME base directory. Entries should be separated with a colon ':'.
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"; export XDG_DATA_DIRS


# Defines the preference-ordered set of base directories to search for configuration files in
# addition to the $XDG_CONFIG_HOME base directory. Entries should be separated with a colon ':'.
XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"; export XDG_CONFIG_DIRS


# Defines the base directory relative to which user-specific non-essential data files should
# be stored.
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"; export XDG_CACHE_HOME
