#!/usr/bin/env zsh


if [ -z "${plugins[*]}" ]; then plugins=(); fi

# Default Oh-My-Zsh plugins.
# This list gets modifed in later hooks (and earlier ones, too).
# Standard plugins can be found in $ZSH/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins+=(
    command-not-found  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found
    compleat  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/compleat
    man  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/man
    sudo  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
    systemadmin  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin
    zsh-defer  # https://github.com/romkatv/zsh-defer
    zsh-you-should-use  # https://github.com/reegnz/jq-zsh-plugin
)
