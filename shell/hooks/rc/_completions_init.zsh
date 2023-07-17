#!/usr/bin/env zsh


if [ -z "$ZSH_VERSION" ]; then return 2; fi


# See: https://zsh.sourceforge.io/Doc/Release/Options.html

# Do NOT autoselect the first completion entry.
unsetopt MENU_COMPLETE

# Automatically use menu completion after the second consecutive request for completion, for example by pressing the tab key repeatedly.
setopt AUTO_MENU

# If a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word.
# That is, the cursor is moved to the end of the word if either a single match is inserted or menu completion is performed.
setopt ALWAYS_TO_END

# Whether or not to perform textual history expansion, e.g. !ls
# Disabled because we'd rather use the Ctrl-R shortcut instead.
unsetopt BANG_HIST

# Don't set the cursor to the end of the word if completion is started. Instead, stay there and perform completion from both ends.
setopt COMPLETE_IN_WORD

# Try to correct the spelling of commands.
# Note that, when the HASH_LIST_ALL option is not set or when some directories in the path are not readable, this may falsely
# report spelling errors the first time some commands are used.
setopt CORRECT
# The shell variable CORRECT_IGNORE may be set to a pattern to match words that will never be offered as corrections.

# Try to correct the spelling of *all* arguments in a line.
setopt CORRECT_ALL
# The shell variable CORRECT_IGNORE_FILE may be set to a pattern to match file names that will never be offered as corrections.

# Disable output flow control via start/stop characters (usually assigned to ^S/^Q) in the shell’s editor.
unsetopt FLOW_CONTROL

# When the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion
# and cycle through them like MENU_COMPLETE. The matches are generated as if a ‘*’ was added to the end of the word, or inserted at the
# cursor when COMPLETE_IN_WORD is set. This actually uses pattern matching, not globbing, so it works not only for files but for any
# completion, such as options, user names, etc.
#
# Note that when the pattern matcher is used, matching control (for example, case-insensitive or anchored matching) cannot be used.
# This limitation only applies when the current word contains a pattern; simply turning on the GLOB_COMPLETE option does not have this effect.
setopt GLOB_COMPLETE

# Whenever a command completion or spelling correction is attempted, make sure the entire command path is hashed first.
# This makes the first completion slower but avoids false reports of spelling errors.
setopt HASH_LIST_ALL

# Do *not* add ‘|’ to output redirections in the history. (To override clobbering-prevention setup by NO_CLOBBER.)
unsetopt HIST_ALLOW_CLOBBER

# Whether or not searching through history should display duplicates.
setopt HIST_FIND_NO_DUPS

# Produces more accurately delimited words when performing history expansion, at the cost of speed.
setopt HIST_LEX_WORDS

# Ignore commands that start with spaces.
setopt HIST_IGNORE_SPACE

# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY

# When listing files that are possible completions, show the type of each file with a trailing identifying mark.
setopt LIST_TYPES


# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"


# Initialize completion
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '~/.zshrc'

# Initialize editing command line
autoload -Uz compinit

# TODO: Make sure this doesn't get run until after Oh-My-Zsh has had a chance to do the final part of its initialization.
compinit

plugins+=(
    zsh-autosuggestions  # https://github.com/zsh-users/zsh-autosuggestions
)
