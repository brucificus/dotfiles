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

# In case we need to manually set our language environment…
LANG="${LANG:-en_US.UTF-8}"; export LANG


# If we're in an interactive shell,
if [[ $- == *i* ]]; then
    # Enable interactive comments (# on the command line)
    setopt INTERACTIVE_COMMENTS
fi
