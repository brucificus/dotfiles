#!/usr/bin/env sh


# Loads functions that help queue up things to source at a later time.

# ⚠️ Part of core "phook" functionality.
#   - Be careful of circular dependencies.
#   - Be careful of POSIX sh compatibility.

phook_caller="${phook_caller:?}"
phook_mode="${phook_mode:?}"
phook_dir="${phook_dir:?}"
phook_loader_q=''
phook_loader_q_length=0
phook_directive_escape_seq=""$'\e'
phook_loader_q_separator=":"

export phook_loader_q
export phook_loader_q_length
export phook_directive_escape_seq
export phook_loader_q_separator



if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=SC3030  # We're in a Bash/ZSH-only block.
    func_deps=(
        _concatenate_paths
        _try_cd_quietly

        strlist_append
        strlist_popend
        strlist_popstart
        strlist_prepend

        _phook_enqueue
        _phook_push

        phook_enqueue_file_optional
        phook_enqueue_file
        phook_enqueue_funcname
        phook_loader_pop
        phook_push_file_optional
        phook_push_file
        phook_push_funcname
    )
    # shellcheck disable=SC3010  # We're in a Bash/ZSH-only block.
    # shellcheck disable=SC3054  # We're in a Bash/ZSH-only block.
    for dep in "${func_deps[@]}"; do
        if [[ "$(type "$dep" 2> /dev/null)" != *"function"* ]]; then
            # shellcheck disable=SC1090 # Dynamic source
            . "$phook_dir/funcs/$dep" || return $?
        fi
    done
else
    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "_concatenate_paths" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/_concatenate_paths" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "_try_cd_quietly" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/_try_cd_quietly" || return $?
    fi


    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "strlist_append" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/strlist_append" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "strlist_popend" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/strlist_popend" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "strlist_popstart" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/strlist_popstart" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "strlist_prepend" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/strlist_prepend" || return $?
    fi


    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "_phook_enqueue" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/_phook_enqueue" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "_phook_push" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/_phook_push" || return $?
    fi


    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_enqueue_file_optional" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_enqueue_file_optional" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_enqueue_file" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_enqueue_file" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_enqueue_funcname" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_enqueue_funcname" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_loader_pop" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_loader_pop" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_push_file_optional" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_push_file_optional" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_push_file" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_push_file" || return $?
    fi

    # shellcheck disable=SC3010  # We're in a POSIX-only block, but we're desperate.
    if [[ "$(type "phook_push_funcname" 2> /dev/null)" != *"function"* ]]; then
        . "$phook_dir/funcs/phook_push_funcname" || return $?
    fi
fi
