#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Functions
source "$SCRIPT_DIR/functions_common.bash"

# Bootstrap
source "$SCRIPT_DIR/bootstrap.bash"

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.bashrc_local_before file
if [ -f ~/.bashrc_local_before ]; then
    source ~/.bashrc_local_before
fi

# Detect Python
source "$SCRIPT_DIR/python_detect.bash"

# Settings
source "$SCRIPT_DIR/settings.bash"

# Aliases
source "$SCRIPT_DIR/aliases_common.bash"

# Plugins
source "$SCRIPT_DIR/plugins.bash"

# Custom prompt
source "$SCRIPT_DIR/prompt.bash"

# Editor
source "$SCRIPT_DIR/editor_detect.bash"

# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.bashrc_local_after file
if [ -f ~/.bashrc_local_after ]; then
    source ~/.bashrc_local_after
fi
