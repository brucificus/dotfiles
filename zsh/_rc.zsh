#!/usr/bin/env zsh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Functions
source "$SCRIPT_DIR/functions_common.zsh"

# Bootstrap
source "$SCRIPT_DIR/bootstrap.zsh"

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

# External plugins (initialized before)
source "$SCRIPT_DIR/plugins_before.zsh"

# Detect Python
source "$SCRIPT_DIR/python_detect.zsh"

# Settings
source "$SCRIPT_DIR/settings.zsh"

# Aliases
source "$SCRIPT_DIR/aliases_common.zsh"

# Custom prompt
source "$SCRIPT_DIR/prompt.zsh"

# External plugins (initialized after)
source "$SCRIPT_DIR/plugins_after.zsh"

# Editor
source "$SCRIPT_DIR/editor_detect.zsh"

# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

# Allow private customizations (not checked in to version control)
if [ -f ~/.shell_private ]; then
    source ~/.shell_private
fi
