#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


# Load dependencies.
if [ -z "$BASH_VERSION" ]; then return 0; fi
# Load dependencies.
_assert_sourced "_bashit_loader.bash" || source "_bashit_loader.bash" || return $?


# Bash-It plugins, completions, and aliases.
# Most of the standard ones, but just the ones I like.
# More are loaded in later hooks.

# Load before other completions.
source "$BASHIT_COMPLETIONS_AVAILABLE"/system.completion.bash

source "$BASHIT_PLUGINS_AVAILABLE"/base.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/base.plugin.bash
source "$BASHIT_PLUGINS_AVAILABLE"/cht-sh.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/cht-sh.plugin.bash
source "$BASHIT_PLUGINS_AVAILABLE"/explain.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/explain.plugin.bash
source "$BASHIT_PLUGINS_AVAILABLE"/sudo.plugin.bash  # https://github.com/Bash-it/bash-it/blob/master/plugins/available/sudo.plugin.bash
source "$BASHIT_COMPLETIONS_AVAILABLE"/defaults.completion.bash
source "$BASHIT_COMPLETIONS_AVAILABLE"/invoke.completion.bash
# source "$BASHIT_ALIASES_AVAILABLE"/bash-it.aliases.bash
