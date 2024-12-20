#!/usr/bin/env sh


phook_caller="$1"; export phook_caller
phook_mode="$2"; export phook_mode
phook_dir="$PWD"; export phook_dir

# Caller: "bash", "zsh", "ssh"
# Mode: "env", "login", "rc", "logout"

_phook_init_final() {
    previous_exit_code=$?
    if [ -d "$phook_dir" ]; then
        _try_cd_quietly "$phook_dir" || true
    fi
    unset phook_dir_realpath
    unset phook_modules_q
    unset phook_dir
    unset phook_mode
    unset phook_caller
    if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
        # shellcheck disable=3041  # We're in a Bash/ZSH-only block.
        set +eE
    else
        set +e
    fi
    return $previous_exit_code
}

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=3041  # We're in a Bash/ZSH-only block.
    set -eE
    # shellcheck disable=3047  # We're in a Bash/ZSH-only block.
    trap _phook_init_final ERR
else
    set -e
fi
. "$phook_dir/funcs/._phook_loader_q_util.sh" || return $?
trap _phook_init_final EXIT
trap _phook_init_final INT
trap _phook_init_final TERM

phook_dir_realpath="$(realpath "$phook_dir")"; export phook_dir_realpath

if [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=SC3030  # We're in a ZSH-only block.
    # shellcheck disable=SC3054  # We're in a ZSH-only block.
    fpath=("$phook_dir"/funcs "${fpath[@]}")
    autoload -Uz "$phook_dir/vendor/zsh-custom/plugins/zsh-defer/zsh-defer"
fi

# Our "hooks" structure relies heavily on files being sourced in a predictable order, most notably requiring that
# underscore-prefixed files be sourced *before* their non-underscored siblings. To ensure this, we set `LC_COLLATE`
# to "C" to ensure that the shell's sorting order is predictable.
export LC_COLLATE=C

set -- "$phook_dir/funcs"
. "./funcs/._index" || _phook_init_final

set -- "$phook_caller" "$phook_mode"
. "./_phook_enqueue_local_before.sh" || _phook_init_final

set -- "$phook_caller" "$phook_mode"
. "./_phook_enqueue_hooks.sh" || _phook_init_final

set -- "$phook_caller" "$phook_mode"
. "./_phook_enqueue_local_after.sh" || _phook_init_final

set -- "$phook_caller" "$phook_mode"
. "./_phook_loader_execute.sh" || _phook_init_final

_phook_init_final
return $?
