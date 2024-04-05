#!/usr/bin/env bash


# Home Assistant CLI
if command_exists ha; then
    if [ -n "$BASH_VERSION" ]; then
        source <(ha completion bash) && compdef _ha ha
    elif [ -n "$ZSH_VERSION" ]; then
        source <(ha completion zsh) && compdef _ha ha
    elif [ -n "$FISH_VERSION" ]; then
        source <(ha completion fish) && complete -c ha -F _ha ha
    fi
fi
