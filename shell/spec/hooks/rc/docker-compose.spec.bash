#!/usr/bin/env bash
eval "$(shellspec - -c) exit 1"
# shellcheck shell=bash


script_under_test="../../../hooks/rc/docker-compose.bash"
Describe "hooks/rc/docker-compose.bash"

    ScriptUnderTestDir="$(realpath "$(dirname "$script_under_test")")"
    ScriptUnderTest="$(basename "$script_under_test")"

    # (Use this from tests that are unsure if a script can even just be sourced.)
    function cd_into_ScriptUnderTestDir() {
        cd "$ScriptUnderTestDir" || return $?
        Include "$ScriptUnderTestDir/../../funcs/_log_info"
        Include "$ScriptUnderTestDir/../../funcs/_assert_sourced"
        Include "$ScriptUnderTestDir/../../funcs/_concatenate_paths"
        Include "$ScriptUnderTestDir/../../funcs/command_exists"
        Include "$ScriptUnderTestDir/../../funcs/append_profile_suggestions"
        _about() { :; } # Mock out _about.
        _param() { :; } # Mock out _param.
        _example() { :; } # Mock out _example.
        _group() { :; } # Mock out _group.
        param() { :; } # Mock out param.
        example() { :; } # Mock out example.
        cite() { :; } # Mock out cite.
        about-plugin() { :; } # Mock out about-plugin.
        about-alias() { :; } # Mock out about-alias.
        BASH_IT="$ScriptUnderTestDir/../../vendor/bash-it"; export BASH_IT
        BASHIT_ALIASES_AVAILABLE="$BASH_IT/aliases/available"; export BASHIT_ALIASES_AVAILABLE
        BASHIT_COMPLETIONS_AVAILABLE="$BASH_IT/completion/available"; export BASHIT_COMPLETIONS_AVAILABLE
        BASHIT_PLUGINS_AVAILABLE="$BASH_IT/plugins/available"; export BASHIT_PLUGINS_AVAILABLE
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
    function Include_ScriptUnderTest() {
        set -e
        cd_into_ScriptUnderTestDir
        Include "$ScriptUnderTest"
        set +e
    }

    # More detailed test(s) of the subject file's functionality.
    Context "defines"
        BeforeEach 'Include_ScriptUnderTest'

    End # Context "defines"
End
