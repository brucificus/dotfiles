#!/usr/bin/env bash


if [ -n "$PLUGINS_BASH_INIT" ]; then
    return
fi
PLUGINS_BASH_INIT=1; export PLUGINS_BASH_INIT


[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"

#
# bash-it enablement.
# NOTE: The "normal" bash-it configuration was done back in ~/settings.bash.
#       We've got some extra stuff here for controlling how bash-it is loaded.
#

# Makes bash-it reload itself automatically after enabling or disabling aliases, plugins, and completions.
export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Check if bash-it has been initalized before.
if [ -d "$BASH_IT/enabled/" ] && [ -n "$(ls -A "$BASH_IT/enabled/" 2>/dev/null)" ] ; then
    # Make note that we don't need to do any extra configuration for bash-it other than telling it to start up.
    PLUGINS_BASH_INIT=2; export PLUGINS_BASH_INIT
fi

log_section_sep="---"
log_section_sep=$(printf "\n%s\n" "$log_section_sep")
BASHIT_INIT_LOG="$HOME/.bashit_init.log"

# Let bash-it startup.
echo "$BASH_IT/bash_it.sh${log_section_sep}" > $BASHIT_INIT_LOG
source "$BASH_IT/bash_it.sh"

if [ "$PLUGINS_BASH_INIT" -gt 1 ]; then
    echo "bash-it already loaded, skipping extra configuration.${log_section_sep}" >> $BASHIT_INIT_LOG
    return
fi
PLUGINS_BASH_INIT=3; export PLUGINS_BASH_INIT

# Tell bash-it to explicitly load our "baseline" profile.
echo "bash-it profile load baseline_profile${log_section_sep}" >> $BASHIT_INIT_LOG
bash-it profile load baseline_profile >> $BASHIT_INIT_LOG


# Which plugins, aliases, and completions would you like to load?
# - Plugins can be found in $BASH_IT/plugins/available.
# - Aliases can be found in $BASH_IT/aliases/available.
# - Completions can be found in $BASH_IT/completions/available.
plugins=()
aliases=()
completions=()

if [ -n "$(which aws)" ]; then
    plugins+=(aws)
    completions+=(awscli)
fi

if [ -n "$(which git)" ]; then
    plugins+=(git)
    completions+=(git_flow git_flow_avh)
    aliases+=(git)
fi

if [ -n "$(which gh)" ]; then
    completions+=(github-cli)
fi

if [ -n "$(which hub)" ]; then
    completions+=(hub)
fi

if [ -n "$(which packer)" ]; then
    completions+=(packer)
fi

DOCKER="$(which docker)"
if [ -n "$DOCKER" ] && [[ $DOCKER != /mnt/* ]]; then
    plugins+=(docker docker-compose)
    completions+=(docker docker-compose)
    aliases+=(docker docker-compose)
fi

if [ -n "$(which docker-machine)" ]; then
    plugins+=(docker-machine)
    completions+=(docker-machine)
fi

if [ -n "$(which dotnet)" ]; then
    completions+=(dotnet)
fi

if [ -n "$(which knife)" ]; then
    completions+=(knife)
fi

NODE="$(which node)"
if [ -n "$NODE" ] && [[ $NODE != /mnt/* ]]; then
    plugins+=(node)
    alises+=(node)
fi

NPM="$(which npm)"
if [ -n "$NPM" ] && [[ "$NPM" != /mnt/* ]]; then
    plugins+=(npm)
    aliases+=(npm)
fi

NVM="$(which nvm)"
if [ -n "$NVM" ] && [[ "$NVM" != /mnt/* ]]; then
    plugins+=(nvm)
fi

if [ -n "$(which java)" ]; then
    plugins+=(java)
fi

if [ -n "$(which maven)" ]; then
    completions+=(maven)
fi

if [ -n "$(which python)" ]; then
    plugins+=(python virtualenv)
fi

if [ -n "$(which pip)" ]; then
    completions+=(pip)
fi

if [ -n "$(which pip3)" ]; then
    completions+=(pip3)
fi

if [ -n "$(which pipenv)" ]; then
    completions+=(pipenv)
fi

if [ -n "$(which conda)" ]; then
    completions+=(conda)
fi

if [ -n "$(which nginx)" ]; then
    completions+=(nginx)
fi

if [ -n "$(which kubectl)" ]; then
    plugins+=(kubectl)
    completions+=(kubectl)
    aliases+=(kubectl)
fi

if [ -n "$(which kubectx)" ]; then
    plugins+=(kubectx)
fi

if [ -n "$(which minikube)" ]; then
    plugins+=(minikube)
    completions+=(minikube)
fi

if [ -n "$(which consul)" ]; then
    completions+=(consul)
fi

if [ -n "$(which terraform)" ]; then
    completions+=(terraform)
    aliases+=(terraform)
fi

if [ -n "$(which terragrunt)" ]; then
    aliases+=(terragrunt)
fi

if [ -n "$(which vagrant)" ]; then
    completions+=(vagrant)
    aliases+=(vagrant)
fi

if [ -n "$(which yarn)" ]; then
    completions+=(yarn)
    aliases+=(yarn)
fi

if [ -n "$(which apt)" ]; then
    aliases+=(apt)
fi

# Do the actual loading.
echo "${log_section_sep}bash-it enable plugin ${plugins[*]}${log_section_sep}" >> $BASHIT_INIT_LOG
bash-it enable plugin "${plugins[@]}" >> "$BASHIT_INIT_LOG"

echo "${log_section_sep}bash-it enable completion ${completions[*]}${log_section_sep}" >> $BASHIT_INIT_LOG
bash-it enable completion "${completions[@]}" >> "$BASHIT_INIT_LOG"

echo "${log_section_sep}bash-it enable alias ${aliases[*]}${log_section_sep}" >> $BASHIT_INIT_LOG
bash-it enable alias "${aliases[@]}" >> $BASHIT_INIT_LOG
