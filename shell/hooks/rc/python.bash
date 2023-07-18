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

if command_exists conda; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/conda.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
else
    append_profile_suggestions "# TODO: 🐍 Install \`conda\`. See: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html."
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
