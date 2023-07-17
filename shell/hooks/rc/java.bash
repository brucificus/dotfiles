#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -n "$BASH_VERSION" ]; then
    _assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?
elif [ -n "$ZSH_VERSION" ]; then
    : # Intentionally left blank.
fi


if command_exists java; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/java.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/java.plugin.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
else
    append_profile_suggestions "# TODO: ☕ Install the OpenJDK. See: https://openjdk.org/install/."
fi

if command_exists maven; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_COMPLETIONS_AVAILABLE"/maven.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
else
    append_profile_suggestions "# TODO: ☕ Install Apache Maven. See: https://maven.apache.org/install.html."
fi

if command_exists gradle; then
    if [ -n "$BASH_VERSION" ]; then
        source "$BASHIT_PLUGINS_AVAILABLE"/gradle.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/gradle.plugin.bash
        source "$BASHIT_COMPLETIONS_AVAILABLE"/gradle.completion.bash
    elif [ -n "$ZSH_VERSION" ]; then
        : # 🙁
    fi
else
    append_profile_suggestions "# TODO: 🐘 Install \`gradle\`. See: https://gradle.org/install/."
fi

