#!/usr/bin/env bash
# shellcheck source-path="SCRIPTDIR/funcs"


# Claim any incoming arguments.
phook_caller="${phook_caller:?}" # Also is $1.
phook_mode="${phook_mode:?}" # Also is $2.
phook_directive_escape_seq="${phook_directive_escape_seq:?}"
phook_dir="${phook_dir:?}"
for _ in "$@"; do shift; done
# Functions available:
# - _try_cd_quietly
# - _assert_sourced
# - phook_enqueue_file
# - phook_enqueue_file_optional
# - phook_enqueue_funcname
# - phook_push_file
# - phook_push_file_optional
# - phook_push_funcname
# - phook_loader_pop


phook_loader_current=''
while phook_loader_pop phook_loader_current; do
    if [[ "$phook_loader_current" =~ ^${phook_directive_escape_seq}.* ]]; then
        # This is a directive.
        : # TODO
        continue
    fi

    if [[ "$phook_loader_current" =~ ^./funcs/.* ]]; then
        expected_function_name="${phook_loader_current##*/}"
        if [[ "$(type "$expected_function_name" 2>/dev/null)" == *"function"* ]]; then
            continue
        fi
    fi

    source "_phook_load_script_file.sh" "$phook_loader_current" || return $?
done
unset phook_loader_current
