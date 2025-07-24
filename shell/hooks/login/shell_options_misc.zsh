#!/usr/bin/env zsh


if [ -z "$ZSH_VERSION" ]; then return 2; fi


# See: https://zsh.sourceforge.io/Doc/Release/Options.html

setopt extendedglob

# Note the location of each command the first time it is executed.
# Subsequent invocations of the same command will use the saved location, avoiding a path search.
setopt HASH_CMDS

# Whenever a command name is hashed, hash the directory containing it, as well as all directories that occur earlier in the path.
setopt HASH_DIRS

# TODO: TBD: HASH_EXECUTABLES_ONLY

# Who the heck uses Linux "mail"? Not this chowder head, that's for sure.
setopt NO_MAIL_WARNING

# Disable allowing `>` top truncate existing files and `>>` to create files.
# Requires using `>|` or `>!` to truncate files and `>>|` or `>>!` to create files.
setopt NO_CLOBBER


# If we're in an interactive shell,
if [[ $- == *i* ]]; then
    # Enable interactive comments (# on the command line).
    setopt INTERACTIVE_COMMENTS

    # Enable filename expansion for arguments of the form ‘anything=expression’.
    setopt magicequalsubst

    # Hide error message if there is no match for the pattern.
    setopt nonomatch

    # Report the status of background jobs immediately.
    setopt notify

    # Sort filenames numerically when it makes sense.
    setopt numericglobsort

    # Enable command substitution in prompt.
    setopt promptsubst


    # Configure key keybindings.
    bindkey -e                                        # emacs key bindings
    bindkey ' ' magic-space                           # do history expansion on space
    bindkey '^U' backward-kill-line                   # ctrl + U
    bindkey '^[[3;5~' kill-word                       # ctrl + Supr
    bindkey '^[[3~' delete-char                       # delete
    bindkey '^[[1;5C' forward-word                    # ctrl + ->
    bindkey '^[[1;5D' backward-word                   # ctrl + <-
    bindkey '^[[5~' beginning-of-buffer-or-history    # page up
    bindkey '^[[6~' end-of-buffer-or-history          # page down
    bindkey '^[[H' beginning-of-line                  # home
    bindkey '^[[F' end-of-line                        # end
    bindkey '^[[Z' undo                               # shift + tab undo last action
fi
