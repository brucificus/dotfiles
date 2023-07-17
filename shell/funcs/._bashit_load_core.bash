#!/usr/bin/env bash


# Enforce that this script be sourced, not executed.
# See: https://stackoverflow.com/a/28776166
(
  [[ -n $ZSH_VERSION && $ZSH_EVAL_CONTEXT =~ :file$ ]] ||
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)
) && sourced=true || sourced=false
if ! $sourced; then
  echo "._bashit_load_core: This script should be sourced, not executed." >&2
  exit 1
fi
# Claim any incoming arguments.
for _ in "$@"; do shift; done


_bashit_lib_path() {
    if [ -z "$1" ]; then
        echo "_bashit_lib_path: 🚨 Bash-It library name is required." >&2
        return 2
    fi
    bashit_lib_path="$(_concatenate_paths "$BASH_IT/lib" "$1".bash)"
    printf '%s' "$bashit_lib_path"
    unset bashit_lib_path
}


# Load Bash-It's logging library, so that its logging works the way it expects it to.
# This overwrites our own logging functions, but we can deal with that later.
bashit_log_lib="$(_bashit_lib_path "log")"
# shellcheck source=../vendor/bash-it/lib/log.bash
_assert_sourced "$bashit_log_lib" || source "$bashit_log_lib" || return $?
unset bashit_log_lib


# Load Bash-It's internal libraries.
BASH_IT_LOG_PREFIX="core: main: "; export BASH_IT_LOG_PREFIX
_log_debug "Loading libraries (except appearance)…"
APPEARANCE_LIB="${BASH_IT}/lib/appearance.bash"; export APPEARANCE_LIB
for _bash_it_main_file_lib in "${BASH_IT}/lib"/*; do
    # Skip Bash-It's appearance (themes) library for now, just like it would.
    [[ "$_bash_it_main_file_lib" = "${BASH_IT}/lib/appearance."* ]] && continue
    _bash-it-log-prefix-by-path "${_bash_it_main_file_lib}"
    _log_debug "Loading library file…"
    # shellcheck disable=SC1090  # Dynamic source.
    _assert_sourced "$_bash_it_main_file_lib" || source "$_bash_it_main_file_lib" || return $?
    BASH_IT_LOG_PREFIX="core: main: "; export BASH_IT_LOG_PREFIX
done
unset APPEARANCE_LIB
unset BASH_IT_LOG_PREFIX

# We purposefully *skip* loading Bash-It's global "enabled" directory.
# We don't want to use Bash-It's mechanisms for enabling/disabling plugins, aliases, etc.


# A function to help with loading Bash-It's internal libraries.



# An alias to help with follow-up loading, in later scripts.
# shellcheck disable=SC2139  # Definition-time expansion is intended.
alias _bashit_load_thing="PWD=\"$PWD\"; source \"$PWD\"/._bashit_load_thing.bash"


unset _bashit_lib_path
_log_info "._bashit_load_core: 🌠 Bash-It core"
