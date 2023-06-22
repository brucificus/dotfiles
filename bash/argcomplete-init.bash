#!/usr/bin/env bash

source ~/.shell/python-detect.sh

if [ -z "$PYTHON3" ]; then
    return
fi

pip_show_argcomplete="$(syspip3 show argcomplete 2> /dev/null)"
if [ -x "$pip_show_argcomplete" ]; then
    # Let argcomplete know that we're planning on using it.
    python3 activate-global-python-argcomplete

    # Next we load up a list of programs that we want to register with argcomplete.
    this_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    readarray -t argcomplete_programs < "$this_dir/../config/argcomplete/compat_programs.txt"
    unset this_dir

    # To avoid calling Python in a loop via 'register-python-argcomplete'
    # (which is slow), we instead call it once to get the script it returns
    # and then reuse it for each of the programs we want to register.
    argcomplete_registration_broker="$(which register-python-argcomplete)"
    target_marker="deadc0d3"
    argcomplete_registration_script="$(python3 "$argcomplete_registration_broker" --shell bash "$target_marker")"
    for prog in "${argcomplete_programs[@]}"; do
        if which "$prog" > /dev/null; then
            eval "${argcomplete_registration_script//$target_marker/$prog}"
        fi
    done
    unset argcomplete_registration_broker
    unset target_marker
    unset argcomplete_registration_script
fi
