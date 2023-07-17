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


# "$HOME/.*_local_after", in reverse order of the equivalent "before" files.
# (Most specific _last_.)
if [ "$phook_caller" = "ssh" ]; then
    phook_enqueue_file_optional "${HOME}/.ssh_local_after"
else
    if [ "$phook_mode" = "rc" ]; then
        phook_enqueue_file_optional "${HOME}/.shell_local_after"
    fi
    phook_enqueue_file_optional "${HOME}/.shell${phook_mode}_local_after"
fi
phook_enqueue_file_optional "${HOME}/.${phook_caller}${phook_mode}_local_after"
