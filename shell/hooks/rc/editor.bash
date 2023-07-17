#!/usr/bin/env bash


# Load dependencies.
if command_exists "edit"; then return 0; fi
# Preferred editors, with fallbacks, varying based on session context.


#
# edit()
#

if [[ -n "$VSCODE" && -z "$SSH_CONNECTION" && ( -z "$WSL_DISTRO_NAME" || "$TERM_PROGRAM" = "vscode" ) ]]; then
    # If VSCode exists and we aren't remotely connected (or in a non-VSCode-hosted WSL session), let's use it.
    # We don't want to use VSCode from within WSL if we aren't also running in a VSCode terminal.
    # Because it's waaaay too slow in those cases.
    edit() {
        $VSCODE ${VSCODE_ARGS[*]} "$@"
    }
elif [ -n "$NANO" ]; then
    # If nano exists, let's use it.
    edit() {
        $NANO ${EDITOR_NANO_ARGS[*]} "$@"
    }
elif [ -n "$NEOVIM" ]; then
    # If neovim exists, let's use it.
    edit() {
        $NEOVIM "$@"
    }
elif [ -n "$VIM" ]; then
    # If vim exists, let's use it.
    edit() {
        $VIM "$@"
    }

    if [ -n "$BASH_VERSION" ]; then
        : # source "$BASHIT_ALIASES_AVAILABLE"/vim.aliases.bash
    elif [ -n "$ZSH_VERSION" ]; then
        plugins+=(vim)
    fi
elif [ -n "$VI" ]; then
    # If vi exists, let's use it.
    edit() {
        $VI "$@"
    }
elif [ -n "$EDITOR" ]; then
    # If $EDITOR is set, let's use it.
    edit() {
        "$EDITOR" "$@"
    }
else
    # Fallback to something every system probably has.
    edit() {
        ed "$@"
    }
fi
