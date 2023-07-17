#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../funcs/strlist_prepend"
Describe "funcs/strlist_prepend"

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
            "strlist_prepend"
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

        Describe "function 'strlist_prepend', which"
            It "exists"
                When call type "strlist_prepend"

                The status should be success
                The output should include "$1 is a shell function"
            End

            Context "given an existing list,"
                Context "list separator, and value to add,"
                    It "adds the value"
                        local list_var="a b c"
                        local list_var_name="list_var"
                        local list_separator=" "
                        local value_to_add="d"
                        local expected_list_result="d a b c"
                        When call strlist_prepend "$list_var_name" "$list_separator" "$value_to_add"

                        The status should be success
                        The variable list_var should equal "$expected_list_result"
                    End
                End
            End

            Context "given an non-existing list,"
                Context "list separator, and value to add,"
                    It "creates the list with the value"
                        unset list_var > /dev/null 2>&1 || true
                        local list_var_name="list_var"
                        local list_separator=" "
                        local value_to_add="d"
                        local expected_list_result="d"
                        When call strlist_prepend "$list_var_name" "$list_separator" "$value_to_add"

                        The status should be success
                        The variable list_var should equal "$expected_list_result"
                    End
                End
            End
        End # Describe "function 'strlist_prepend'""

    End # Context "defines"
End
