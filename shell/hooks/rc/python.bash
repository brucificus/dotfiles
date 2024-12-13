#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


if command_exists _python3; then
    alias python3='_python3'
    alias py='_python3'
fi

if command_exists _pip3; then
    alias pip3='_pip3'
fi

if command_exists _syspip3; then
    alias syspip3='_syspip3'
fi

if command_exists _pip3_package_location; then
    alias pip3_package_location='_pip3_package_location'
fi

if command_exists _syspip3_package_location; then
    alias syspip3_package_location='_syspip3_package_location'
fi

if command_exists python3; then
    alias py='python3'
fi

if command_exists ipython3; then
    alias ipy='ipython3'
fi

if command_exists pip3; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/pip3.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # Intentionally left blank.
    fi
fi

if binary_exists pip2; then
    # Use pip2 without requiring virtualenv.
    syspip2() {
        PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
    }
fi

if command_exists pip; then
    # Use pip without requiring virtualenv.
    syspip() {
        PIP_REQUIRE_VIRTUALENV="" pip "$@"
    }

    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/pip.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            pip  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pip
        )
    fi
fi

if command_exists pipenv; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/pipenv.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            pipenv  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pipenv
        )
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install \`pipenv\`. See: https://github.com/pypa/pipenv#installation."
fi

if command_exists pyenv || command_exists virtualenvwrapper.sh; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/pyenv.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/pyenv.plugin.bash
        source "$BASHIT_PLUGINS_AVAILABLE"/virtualenv.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/virtualenv.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            virtualenv  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenv
            virtualenvwrapper  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenvwrapper
        )
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install \`pyenv\` See: https://github.com/pyenv/pyenv#installation."
fi

# If ~/miniconda3/bin/activate exists and `conda` is not in the PATH, source it.
if [ -f ~/miniconda3/bin/activate ] && ! command_exists conda; then
    source ~/miniconda3/bin/activate
fi

CONDA="$HOME/miniconda3/bin/conda"
if [ -f "$CONDA" ] && ! command_exists conda; then
    path
fi


if command_exists conda; then
    if [ -n "$BASH_VERSION" ]; then
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
                . "$HOME/miniconda3/etc/profile.d/conda.sh"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    elif [ -n "$ZSH_VERSION" ]; then
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/home/bruce/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
                . "$HOME/miniconda3/etc/profile.d/conda.sh"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install \`conda\`. Run ~/.dotfiles/bin/install_miniconda3.sh"
fi

if command_exists uv; then
    : # 😊
else
    append_profile_suggestions "# TODO: 🐍 Install \`uv\`. Run: ~/.dotfiles/bin/install_uv.sh"
fi

if command_exists pylint; then
    if [ -n "$BASH_VERSION" ]; then
        : # 🙁
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(
            pylint  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/pylint
        )
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install \`pylint\`. See: https://pylint.org/#install."
fi


if command_exists python || command_exists python3; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/python.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/python.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # Intentionally left blank.
    fi
fi
