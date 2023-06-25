#!/usr/bin/env zsh

# External plugins (initialized before)


[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages compleat copybuffer dirhistory dotenv emoji github gpg-agent jira sudo virtualenv zsh-autosuggestions zsh-syntax-highlighting)

if [ -n "$(whence git)" ]; then
    plugins+=(git)
fi

local DOCKER="$(whence docker)"
if [ -n "$DOCKER" ] && [[ $DOCKER != /mnt/* ]]; then
    plugins+=(docker docker-compose)
fi

if [ -n "$(whence docker-machine)" ]; then
    plugins+=(docker-machine)
fi

if [ -n "$(whence dotnet)" ]; then
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

if [ -n "$(whence pipenv)" ]; then
    plugins+=(pipenv)
fi

if [ -n "$(whence kubectl)" ]; then
    plugins+=(kubectl)
fi

if [ -n "$(whence kubectx)" ]; then
    plugins+=(kubectx)
fi

if [ -n "$(whence minikube)" ]; then
    plugins+=(minikube)
fi

if [ -n "$(whence code)" ]; then
    plugins+=(vscode)
fi
