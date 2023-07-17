#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../funcs/strlist_popend"
Describe "funcs/strlist_popend"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        : # TODO: 🔧 source those dependencies.
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "strlist_popend"
        End

        Example "$1"
            # This must use full path to script because, even though shellspec will run the script under the context
            # established by Before* test setups, it does not respect them when evaluating `When run source`.
            When run source "$ScriptUnderTestDir/$ScriptUnderTest"

            The status should be success
            The output should be blank
            The function "$1" should be defined
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

        Describe "function 'strlist_popend', which"
            It "exists"
                When call type "strlist_popend"

                The status should be success
                The output should include "$1 is a shell function"
            End

            Context "given an existing list variable name, list separator, and name of variable to output into"
                It "pops the value"
                    local list_var="a b c d"
                    local list_var_name="list_var"
                    local list_separator=" "
                    local output_var=''
                    local output_var_name="output_var"
                    local expected_list_result="a b c"
                    local expected_output_result="d"

                    When call strlist_popend "$list_var_name" "$list_separator" "$output_var_name"

                    The status should be success
                    The variable output_var should equal "$expected_output_result"
                    The variable list_var should equal "$expected_list_result"
                End
            End

            Context "given an empty list, list separator, and name of variable to output into"
                It "pops nothing"
                    local list_var=""
                    local list_var_name="list_var"
                    local list_separator=" "
                    local output_var=''
                    local output_var_name="output_var"
                    local expected_list_result=""
                    local expected_output_result=""

                    When call strlist_popend "$list_var_name" "$list_separator" "$output_var_name"

                    The status should be failure
                    The variable output_var should equal "$expected_output_result"
                    The variable list_var should equal "$expected_list_result"
                End
            End

            Context "given a single-item list, list separator, and name of variable to output into"
                It "pops last item"
                    local list_var="b"
                    local list_var_name="list_var"
                    local list_separator=" "
                    local output_var=''
                    local output_var_name="output_var"
                    local expected_list_result=""
                    local expected_output_result="b"

                    When call strlist_popend "$list_var_name" "$list_separator" "$output_var_name"

                    The status should be success
                    The variable output_var should equal "$expected_output_result"
                    The variable list_var should equal "$expected_list_result"
                End
            End
        End # Describe "function 'strlist_popend'""

    End # Context "defines"
End
