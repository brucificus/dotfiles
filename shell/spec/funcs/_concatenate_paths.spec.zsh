#!/usr/bin/env zsh
eval "$(shellspec - -c) exit 1"
# shellcheck shell=zsh


script_under_test="../../funcs/_concatenate_paths"
Describe "funcs/_concatenate_paths"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
    }

    # Test(s) that the subject file doesn't have any major structural/syntax issues.
    Context "when sourced"
        BeforeEach 'cd_into_ScriptUnderTestDir'

        Parameters
            "_concatenate_paths"
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

        Describe "function '_concatenate_paths', which"
            It "exists"
                When call type "_concatenate_paths"

                The status should be success
                The output should include "$1 is a shell function"
            End

            Context "given two absolute paths"
                It "outputs second path"
                    local -r path1="/path/1"
                    local -r path2="/path/2"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given two blank values"
                It "returns nothing"
                    local -r path1=""
                    local -r path2=""
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal ""
                End
            End

            Context "given a pair of path fragments"
                It "returns the path fragments joined together"
                    local -r path1="abc/def"
                    local -r path2="hij/klm"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1/$path2"
                End
            End

            Context "given a blank path and an absolute path"
                It "outputs non-blank path"
                    local -r path1=""
                    local -r path2="/path/2"

                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given blank path and non-blank path fragment"
                It "outputs non-blank path fragment"
                    local -r path1=""
                    local -r path2="path/2"

                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given '.' path and an absolute path"
                It "outputs second path"
                    local -r path1="."
                    local -r path2="/path/2"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given '.' path and a path fragment"
                It "outputs path fragment"
                    local -r path1="."
                    local -r path2="path/2"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given './' path and an absolute path"
                It "outputs second path"
                    local -r path1="./"
                    local -r path2="/path/2"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End

            Context "given './' path and a path fragment"
                It "outputs second path"
                    local -r path1="./"
                    local -r path2="path/2"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path2"
                End
            End


            Context "given an absolute path and a blank path"
                It "outputs non-blank path"
                    local -r path1="/path/1"
                    local -r path2=""

                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End

            Context "given non-blank path fragment and a blank path"
                It "outputs non-blank path fragment"
                    local -r path1="path/2"
                    local -r path2=""

                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End

            Context "given an absolute path and a '.' path"
                It "outputs first path"
                    local -r path1="/path/1"
                    local -r path2="."
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End

            Context "given a path fragment and a '.' path"
                It "outputs first path"
                    local -r path1="path/1"
                    local -r path2="."
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End

            Context "given an absolute path and a './' path"
                It "outputs first path"
                    local -r path1="/path/1"
                    local -r path2="./"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End

            Context "given a path fragment and a './' path"
                It "outputs first path"
                    local -r path1="path/1"
                    local -r path2="./"
                    When call _concatenate_paths "$path1" "$path2"

                    The status should be success
                    The output should equal "$path1"
                End
            End
        End # Describe "function '_concatenate_paths'""

    End # Context "defines"
End
