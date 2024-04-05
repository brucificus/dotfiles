#!/usr/bin/env bash
# shellcheck source-path="SCRIPTDIR/funcs"


# Sources a script file. Carefully.
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=3041  # We're in a Bash/ZSH-only block.
    set -eE
else
    set -e
fi
# Claim any incoming arguments.
phook_caller="${phook_caller:?}"
phook_mode="${phook_mode:?}"
phook_dir="${phook_dir:?}"
phook_dir_realpath="${phook_dir_realpath:?}"
SCRIPT="${1:?}"
# Functions available:
# - _try_cd_quietly
# - _assert_sourced
# - phook_enqueue_file
# - phook_enqueue_file_optional
# - phook_enqueue_funcname
# - phook_push_file
# - phook_push_file_optional
# - phook_push_funcname


pathing_exit_code=0
SCRIPT="$(realpath "$SCRIPT")" || pathing_exit_code=$?
SCRIPT_O="$1"
if [ "$pathing_exit_code" -ne 0 ]; then
    echo "[$phook_caller|$phook_mode] Pathing failed for '$SCRIPT_O', returned code '$pathing_exit_code'." >&2
    unset SCRIPT_O
    unset SCRIPT
    return "$pathing_exit_code"
fi
unset pathing_exit_code
shift 1

SCRIPT_DIR="$(dirname "$SCRIPT")"; export SCRIPT_DIR
if [[ "$SCRIPT" =~ ^$phook_dir_realpath/.* ]]; then
    SCRIPT_PWD="${SCRIPT_DIR}"; export SCRIPT_PWD
elif [[ "$SCRIPT" =~ ^$HOME/.* ]]; then
    SCRIPT_PWD="${HOME}"; export SCRIPT_PWD
else
    SCRIPT_PWD="${SCRIPT_DIR}"; export SCRIPT_PWD
fi
SCRIPT_0="$(basename "$SCRIPT")"; export SCRIPT_0
sourcing_exit_code=0

cd "$SCRIPT_PWD" || return $?

sourcing_exit_code=0
# if [ -n "$ZSH_VERSION" ] && whence zsh-defer > /dev/null; then
#     echo "[$phook_caller|$phook_mode] Deferred sourcing of component: $SCRIPT_O" >&2
#     # shellcheck disable=SC1090  # Dynamic source.
#     _assert_sourced "$SCRIPT" "$@" || {
#         zsh-defer +12 -t 0.001 source "\"$SCRIPT\"" "$@"
#     }
# else
    echo "[$phook_caller|$phook_mode] Sourcing component: $SCRIPT_O" >&2
    # shellcheck disable=SC1090  # Dynamic source.
    _assert_sourced "$SCRIPT" "$@" || {
        . "$SCRIPT" "$@" || sourcing_exit_code=$?
    }
# fi

unset SCRIPT_0
unset SCRIPT_PWD
unset SCRIPT_DIR
unset SCRIPT_O
unset SCRIPT

if [ "$sourcing_exit_code" -ne 0 ]; then
    echo "[$phook_caller|$phook_mode] Sourcing component failed, returned code '$sourcing_exit_code'." >&2
fi
cd "$phook_dir_realpath" > /dev/null || true
return $sourcing_exit_code
