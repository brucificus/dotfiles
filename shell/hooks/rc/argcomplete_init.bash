#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/../../funcs


compat_programs_file="$PWD/../../../config/argcomplete/compat_programs.txt"

if command_exists "pip"; then
    : # Intentionally left blank.
else
    return
fi

argcomplete_package="$(_pip_package_location argcomplete)"
if [ -z "$argcomplete_package" ]; then
    append_profile_suggestions "pip install argcomplete  # 🧑‍💻 Install argcomplete."
    return
fi

# Run argcomplete's initialization script for bash.
source "$argcomplete_package/bash_completion.d/_python-argcomplete"

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
