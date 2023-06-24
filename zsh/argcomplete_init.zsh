#!/usr/bin/env zsh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

if [ -z "$ARGCOMPLETE_INIT_ZSH" ]; then
    source "$SCRIPT_DIR/settings.zsh"
    source "$SCRIPT_DIR/python_detect.zsh"

    if [ -z "$PYTHON3" ]; then
        return
    fi

    argcomplete_package="$(pip3_package_location argcomplete)"
    if [ -z "$argcomplete_package" ]; then
        argcomplete_package="$(syspip3_package_location argcomplete)"
    fi
    if [ -z "$argcomplete_package" ]; then
        return
    fi

    # Register argcomplete's initialization script with ZSH.
    fpath=( "$argcomplete_package/bash_completion.d" "${fpath[@]}" )

    # Make sure we don't run the global initialization script more than once.
    ARGCOMPLETE_INIT_ZSH=0; export ARGCOMPLETE_INIT_ZSH
fi

if [ "$ARGCOMPLETE_INIT_ZSH" -lt 1 ]; then
    # Find the available argcomplete per-program registration script.
    if [ -n "$(whence register-python-argcomplete)" ]; then
        register_argcomplete="register-python-argcomplete"
    elif [ -n "$(whence register-python-argcomplete3)" ]; then
        register_argcomplete="register-python-argcomplete3"
    else
        # This script gets sourced multiple times but can't always complete when it gets called the first time.
        # So we'll quietly exit and hope the next run works.
        return
    fi

    # Next we load up a list of programs that we want to *expressly* register with argcomplete. From a file.
    compat_programs_file="$SCRIPT_DIR/../config/argcomplete/compat_programs.txt"
    argcomplete_programs=()
    while read -r line; do
        argcomplete_programs+=("$line")
    done < "$compat_programs_file"

    # Call the argcomplete per-program registration script for each of the programs that we have.
    for prog in "${argcomplete_programs[@]}"; do
        prog_path="$(whence "$prog")"
        if [ -n "$prog_path" ]; then
            register_argcomplete_output_cmd="$("$register_argcomplete" --shell bash $prog)"
            eval "$register_argcomplete_output_cmd"
        fi
    done

    # Make sure we don't run the program registration loop more than once.
    ARGCOMPLETE_INIT_ZSH=1; export ARGCOMPLETE_INIT_ZSH
fi
