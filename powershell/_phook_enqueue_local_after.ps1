#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# "$HOME/.*_local_after.ps1", in reverse order of the equivalent "before" files.
# (Most specific _last_.)
if ($Global:phook_caller -eq "ssh") {
    # TODO. Does this even happen for pwsh?
    phook_enqueue_file_optional "~/.ssh_local_after.ps1"
} else {
    if ($Global:phook_mode -eq "rc") {
        phook_enqueue_file_optional "~/.shell_local_after.ps1"
    }
    phook_enqueue_file_optional "~/.shell${Global:phook_mode}_local_after.ps1"
}
phook_enqueue_file_optional "~/.${Global:phook_caller}${Global:phook_mode}_local_after.ps1"
