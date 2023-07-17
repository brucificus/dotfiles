#!/usr/bin/env bash


if [ -z "$BASH_VERSION" ]; then return 0; fi


for _bash_it_library_finalize_f in "${_bash_it_library_finalize_hook[@]:-}"; do
    eval "${_bash_it_library_finalize_f?}" # Use `eval` to achieve the same behavior as `$PROMPT_COMMAND`.
done
unset "${!_bash_it_library_finalize_@}" "${!_bash_it_main_file_@}"


unset BASHIT_PLUGINS_AVAILABLE
unset BASHIT_COMPLETIONS_AVAILABLE
unset BASHIT_ALIASES_AVAILABLE
