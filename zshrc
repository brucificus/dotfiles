# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Functions
source ~/.shell/functions.sh

# Bootstrap
source ~/.shell/bootstrap.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

# External plugins (initialized before)
source ~/.zsh/plugins_before.zsh

# Detect Python
source ~/.shell/python-detect.sh

# Settings
source ~/.zsh/settings.zsh

# Aliases
source ~/.shell/aliases.sh

# Custom prompt
source ~/.zsh/prompt.zsh

# External plugins (initialized after)
source ~/.zsh/plugins_after.zsh

# Editor
source ~/.shell/editor.sh

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
