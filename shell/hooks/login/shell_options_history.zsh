#!/usr/bin/env zsh


if [ -z "$ZSH_VERSION" ]; then return 2; fi
# See: https://zsh.sourceforge.io/Doc/Release/Options.html


# History options for Zsh-proper.
SAVEHIST=1048576; export SAVEHIST
HISTSIZE=1153433; export HISTSIZE
HISTFILE="$HOME/.zsh_history"; export HISTFILE

# Start out setting that we want to append the history list to the history file, rather than replace it.
setopt APPEND_HISTORY

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
setopt EXTENDED_HISTORY

# Expand upon APPEND_HISTORY by configuring such that except that new history lines are added to the $HISTFILE
# incrementally - *as soon as they are entered*, rather than waiting until the shell exits.
# Where possible, the history entry is written out to the file after the command is finished, so that the time
# taken by the command is recorded correctly in the history file in EXTENDED_HISTORY format.
unsetopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
# (This means that the history entry will not be available immediately from other instances of the shell that are using
# the same history file.)

# TODO: TBD: SHARE_HISTORY
# on or off? Has weird conflicts with above.
# Docs (https://zsh.sourceforge.io/Doc/Release/Options.html) say might need
# to manually import history with `fc -RI` when *not* using this option.

# Expire a duplicate event first when trimming history. Requires HISTSIZE > SAVEHIST.
setopt HIST_EXPIRE_DUPS_FIRST

# Better performance when multiple shells are updating the history file simultaneously, on newer OSes.
setopt HIST_FCNTL_LOCK

# If a new command line being added to the history list duplicates an older one, the older command is *kept* in the list (irrespective of if it is the previous event).
unsetopt HIST_IGNORE_ALL_DUPS

# Allow command lines into the history list even if they are duplicates of the previous event.
unsetopt HIST_IGNORE_DUPS

# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS

# When writing out the history file, retain older commands that duplicate newer ones.
unsetopt HIST_SAVE_NO_DUPS


# Just OMZ things.

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
