#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/aliases/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/completion/available
# shellcheck source-path=SCRIPTDIR/../../vendor/bash-it/plugins/available


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists node; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/node.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/node.plugin.bash
        source "$BASHIT_ALIASES_AVAILABLE"/node.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(node)  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/node
    fi
elif command_exists nvm; then
    append_profile_suggestions "# TODO: 🔨 Add \`node\` to your PATH. (Have you run NVM yet?)"
fi

if command_exists npm; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_ALIASES_AVAILABLE"/npm.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            npm  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm
            zsh-better-npm-completion  # https://github.com/lukechilds/zsh-better-npm-completion
        )
    fi
elif command_exists nvm; then
    append_profile_suggestions "# TODO: 🔨 Add \`npm\` to your PATH. (Have you run NVM yet?)"
fi

NVM_COMPLETION=true; export NVM_COMPLETION
NVM_LAZY_LOAD=true; export NVM_LAZY_LOAD
NVM_AUTO_USE=true; export NVM_AUTO_USE
if [ -n "$BASH_VERSION" ]; then
    autoload() { :; }
    add-zsh-hook() { :; }
    source "./../../vendor/zsh-custom/plugins/zsh-nvm/zsh-nvm.plugin.zsh"  # https://github.com/lukechilds/zsh-nvm, swears it works for bash too.
    unset -f add-zsh-hook
    unset -f autoload

    source "$BASHIT_PLUGINS_AVAILABLE"/nvm.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/nvm.plugin.bash
elif [ -n "$ZSH_VERSION" ]; then
    plugins+=(
        zsh-nvm  # https://github.com/lukechilds/zsh-nvm
        nvm  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nvm
    )
elif ! command_exists nvm; then
    unset NVM_AUTO_USE
    unset NVM_LAZY_LOAD
    unset NVM_COMPLETION
    append_profile_suggestions "# TODO: 🔨 Add \`nvm\` to your PATH."
fi

if command_exists gulp; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/gulp.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
fi

if command_exists grunt; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/grunt.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
fi

if command_exists yarn; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/yarn.completion.bash
        source "$BASHIT_ALIASES_AVAILABLE"/yarn.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            zsh-yarn-autocompletions  # https://github.com/g-plane/zsh-yarn-autocompletions
        )
    fi
else
    append_profile_suggestions "# TODO: 🧶 Install \`yarn\`. See: https://yarnpkg.com/getting-started/install/."
fi
