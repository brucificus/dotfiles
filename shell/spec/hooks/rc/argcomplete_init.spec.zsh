#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../../hooks/rc/argcomplete_init.zsh"
Describe "hooks/rc/argcomplete_init.zsh"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        source "$ScriptUnderTestDir/../../funcs/command_exists" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/find_binary" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/_python3" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/_pip3" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/_syspip3" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/_pip3_package_location" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/_syspip3_package_location" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/append_profile_suggestions" &> /dev/null
        source "$ScriptUnderTestDir/../../funcs/shell_actual" &> /dev/null
        compdef() { :; } # Mock out compdef.
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        It "succeeds"
            # This must use full path to script because, even though shellspec will run the script under the context
            # established by Before* test setups, it does not respect them when evaluating `When run source`.
            When run source "$ScriptUnderTestDir/$ScriptUnderTest"

            The status should be success
            The output should be blank
        End
    End

    # (Use this from tests that assume the subject file can be loaded without major problems.)
    function source_ScriptUnderTest() {
        set -e
        cd_into_ScriptUnderTestDir
        source "$ScriptUnderTest" &> /dev/null
        set +e
    }

    # More detailed test(s) of the subject file's functionality.
    Context "defines"
        BeforeEach 'source_ScriptUnderTest'

    End # Context "defines"
End
