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


# First up SSH's system-wide rc file, because SSH will skip it as a
# result of us having provided a custom one in the user's profile.
if [ "$phook_caller$phook_mode" = "sshrc" ]; then
    phook_enqueue_file_optional "/etc/ssh/sshrc"
fi


# "$HOME/.*_local_before"
# (Most specific first.)
phook_enqueue_file_optional "${HOME}/.${phook_caller}${phook_mode}_local_before"
if [ "$phook_caller" = "ssh" ]; then
    phook_enqueue_file_optional "${HOME}/.ssh_local_before"
else
    phook_enqueue_file_optional "${HOME}/.shell${phook_mode}_local_before"
    if [ "$phook_mode" = "rc" ]; then
        phook_enqueue_file_optional "${HOME}/.shell_local_before"
    fi
fi
