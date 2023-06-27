#!/usr/bin/env zsh

# External plugins (initialized before)

if [ -n "$ZSH_PLUGINS_INIT" ]; then
    return
fi
ZSH_PLUGINS_INIT=1; export ZSH_PLUGINS_INIT


[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages compleat copybuffer dirhistory dotenv emoji github gpg-agent jira sudo virtualenv)

if binary_exists git; then
    plugins+=(git)
fi

local DOCKER="$(whence docker)"
if [ -n "$DOCKER" ] && [[ $DOCKER != /mnt/* ]]; then
    plugins+=(docker docker-compose)
fi

if binary_exists docker-machine; then
    plugins+=(docker-machine)
fi

if binary_exists dotnet; then
    plugins+=(dotnet)
fi

local NODE="$(whence node)"
if [ -n "$NODE" ] && [[ $NODE != /mnt/* ]]; then
    plugins+=(node)
fi

local NPM="$(whence npm)"
if [ -n "$NPM" ] && [[ "$NPM" != /mnt/* ]]; then
    plugins+=(npm)
fi

local NVM="$(whence nvm)"
if [ -n "$NVM" ] && [[ "$NVM" != /mnt/* ]]; then
    plugins+=(nvm)
fi

if command_exists pipenv; then
    plugins+=(pipenv)
fi

if command_exists kubectl; then
    plugins+=(kubectl)
fi

if command_exists kubectx; then
    plugins+=(kubectx)
fi

if command_exists minikube; then
    plugins+=(minikube)
fi

if command_exists code; then
    plugins+=(vscode)
fi

plugins+=(zsh-autosuggestions zsh-syntax-highlighting wsl-notify-zsh zsh-256color)
