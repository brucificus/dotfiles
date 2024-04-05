#!/usr/bin/env bash


# Home Assistant CLI
if command_exists ha; then
    if [ -n "$BASH_VERSION" ]; then
        source <(ha completion bash)
    elif [ -n "$ZSH_VERSION" ]; then
        source <(ha completion zsh)
    elif [ -n "$FISH_VERSION" ]; then
        source <(ha completion fish)
    fi
fi
