#!/usr/bin/env bash
# shellcheck source-path="SCRIPTDIR/funcs"


# Queues up things to source by adding them to the phook_loader_q variable.
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=3041  # We're in a Bash/ZSH-only block.
    set -eE
else
    set -e
fi
# Claim any incoming arguments.
phook_caller="${phook_caller:?}" # Also is $1.
phook_mode="${phook_mode:?}" # Also is $2.
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


# "./funcs/*"
for func_file in "./funcs/"*; do
    expected_func_name="${func_file##*/}"
    expected_func_name="${expected_func_name%.sh}"
    if ! type "$expected_func_name" &> /dev/null; then
        phook_enqueue_file "$func_file"
    fi
    unset expected_func_name
done
