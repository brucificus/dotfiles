#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# First up SSH's system-wide rc file, because SSH will skip it as a
# result of us having provided a custom one in the user's profile.
if ("${Global:phook_caller}${Global:phook_mode}" -eq "sshrc") {
    # TODO. (This global file won't be for powershell.)
    #           Does this even happen for pwsh?
    phook_enqueue_file_optional "/etc/ssh/sshrc"
}


# "$HOME/.*_local_before.ps1"
# (Most specific first.)
phook_enqueue_file_optional "~/.${Global:phook_caller}${Global:phook_mode}_local_before.ps1"
if ($Global:phook_caller -eq "ssh") {
    # TODO. Does this even happen for pwsh?
    phook_enqueue_file_optional "~/.ssh_local_before.ps1"
} else {
    phook_enqueue_file_optional "~/.shell${phook_mode}_local_before.ps1"
    if ($Global:phook_mode-eq "rc") {
        phook_enqueue_file_optional "~/.shell_local_before.ps1"
    }
}
