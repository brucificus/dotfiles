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


# "./hooks/$phook_mode/*"
shell_suffix_precedence=''
if [ -n "$BASH_VERSION" ]; then
    shell_suffix_precedence='.bash:.sh'
elif [ -n "$ZSH_VERSION" ]; then
    shell_suffix_precedence='.zsh:.bash:.sh'
else
    echo "_phook_enqueue_hooks: Unsupported shell." >&2
    return 2
fi
current_suffix=''
higher_precedence_suffixes=''
hooks_dir="./hooks/$phook_mode"

unset restore_zsh_null_glob_enabled || true
if [ -n "$ZSH_VERSION" ]; then
    setopt -o null_glob || restore_zsh_null_glob_enabled=$?
    setopt null_glob
fi
found_hook_files=''
while strlist_popstart shell_suffix_precedence ":" current_suffix; do
    foundy_any_hooks=0
    find "$hooks_dir"/*"$current_suffix" > /dev/null 2>&1 || foundy_any_hooks=$?
    if [ $foundy_any_hooks -ne 0 ]; then
        continue
    fi
    for hook_file in "$hooks_dir/"*"$current_suffix"; do
        if [ ! -r  "$hook_file" ]; then
            echo "_phook_enqueue_hooks: Unreadable file: $hook_file" >&2
            continue
        fi
        should_enqueue=-1
        if [ -z "$higher_precedence_suffixes" ]; then
            should_enqueue=0
        else
            hook_file_basename="$(basename -s "$current_suffix" "$hook_file")"
            # shellcheck disable=SC2034  # We're using dynamically.
            suffixes_to_check="$higher_precedence_suffixes"
            possible_previous_suffix=''
            should_enqueue=0  # Until we know better, plan on using it.
            while strlist_popstart suffixes_to_check ":" possible_previous_suffix; do
                if [ -r "$hooks_dir/${hook_file_basename}$possible_previous_suffix" ]; then
                    should_enqueue=1  # We already sourced a higher-precedence version.
                    break
                fi
            done
            unset possible_previous_suffix
            unset suffixes_to_check
            unset hook_file_basename
        fi
        if [ "$should_enqueue" -eq 0 ]; then
            strlist_append found_hook_files $'\n' "$hook_file"
        fi
    done
    strlist_append higher_precedence_suffixes ":" "$current_suffix"
done < <(printf '%s' "$shell_suffix_precedence")
if [ -n "$ZSH_VERSION" ]; then
    if [ -n "${restore_zsh_null_glob_enabled+x}" ]; then
        if [ "$restore_zsh_null_glob_enabled" -eq 0 ]; then
            setopt null_glob
        else
            unsetopt null_glob
        fi
        unset restore_nullglob_enabled
    fi
fi
unset current_suffix
unset higher_precedence_suffixes
unset shell_suffix_precedence

# Sort the list.
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    sorted_found_hook_files="$(echo "$found_hook_files" | sort --stable --unique)"
    unset IFS; while read -r hook_file; do
        phook_enqueue_file "$hook_file"
    done < <(echo "$sorted_found_hook_files")
else
    echo "_phook_enqueue_hooks: Unsupported shell." >&2
    return 2
fi
unset found_hook_files
