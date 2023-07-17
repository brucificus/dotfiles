#!/usr/bin/env zsh
# shellcheck source-path=SCRIPTDIR/../../funcs


compat_programs_file="$PWD/../../../config/argcomplete/compat_programs.txt"

if [ -z "$PYTHON3" ]; then
    return
fi

argcomplete_package="$(_pip3_package_location argcomplete)"
if [ -z "$argcomplete_package" ]; then
    argcomplete_package="$(_syspip3_package_location argcomplete)"
fi
if [ -z "$argcomplete_package" ]; then
    append_profile_suggestions "syspip3 install argcomplete  # 🧑‍💻 Install argcomplete."
    return
fi

# Register argcomplete's initialization script with ZSH.
fpath=( "$argcomplete_package/bash_completion.d" "${fpath[@]}" )

# Find the available argcomplete per-program registration script.
if command_exists "register-python-argcomplete"; then
    register_argcomplete="register-python-argcomplete"
elif command_exists "register-python-argcomplete3"; then
    register_argcomplete="register-python-argcomplete3"
else
    return 2
fi

# Next we load up a list of programs that we want to *expressly* register with argcomplete. From a file.
argcomplete_programs=()
while read -r line; do
    argcomplete_programs+=("$line")
done < "$compat_programs_file"

# Call the argcomplete per-program registration script for each of the programs that we have.
for prog in "${argcomplete_programs[@]}"; do
    if command_exists "$prog"; then
        register_argcomplete_output_cmd="$("$register_argcomplete" --shell "$(shell_actual)" "$prog")"
        eval "$register_argcomplete_output_cmd"
    fi
done
