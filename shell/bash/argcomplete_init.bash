#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
compat_programs_file="$SCRIPT_DIR/../../config/argcomplete/compat_programs.txt"


if [ -z "$ARGCOMPLETE_INIT_BASH" ]; then
    source "$SCRIPT_DIR/settings.bash"
    source "$SCRIPT_DIR/python_detect.bash"

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

    # Run argcomplete's initialization script for bash.
    source "$argcomplete_package/bash_completion.d/_python-argcomplete"

    # Make sure we don't run the global initialization script more than once.
    ARGCOMPLETE_INIT_BASH=0; export ARGCOMPLETE_INIT_BASH
fi

if [ "$ARGCOMPLETE_INIT_BASH" -lt 1 ]; then
    # Find the available argcomplete per-program registration script.
    if [ -n "$(which register-python-argcomplete)" ]; then
        register_argcomplete="register-python-argcomplete"
    elif [ -n "$(which register-python-argcomplete3)" ]; then
        register_argcomplete="register-python-argcomplete3"
    else
        # This script gets sourced multiple times but can't always complete when it gets called the first time.
        # So we'll quietly exit and hope the next run works.
        return
    fi

    # Next we load up a list of programs that we want to *expressly* register with argcomplete.
    readarray -t argcomplete_programs < "$compat_programs_file"

    # Call the argcomplete per-program registration script for each of the programs that we have.
    for prog in "${argcomplete_programs[@]}"; do
        prog_path="$(which "$prog")"
        if [ -n "$prog_path" ]; then
            register_argcomplete_output_cmd="$("$register_argcomplete" --shell bash $prog)"
            eval "$register_argcomplete_output_cmd"
        fi
    done

    # Make sure we don't run the program registration loop more than once.
    ARGCOMPLETE_INIT_BASH=1; export ARGCOMPLETE_INIT_BASH
fi
