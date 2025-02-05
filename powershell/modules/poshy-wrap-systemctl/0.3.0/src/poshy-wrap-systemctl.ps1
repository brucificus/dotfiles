#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


# systemctl aliases
[string[]] $user_commands = @(
    "cat",
    "get-default",
    "help",
    "is-active",
    "is-enabled",
    "is-failed",
    "is-system-running",
    "list-dependencies",
    "list-jobs",
    "list-sockets",
    "list-timers",
    "list-unit-files",
    "list-units",
    "show",
    "show-environment",
    "status"
)

[string[]] $sudo_commands = @(
    "add-requires",
    "add-wants",
    "cancel",
    "daemon-reexec",
    "daemon-reload",
    "default",
    "disable",
    "edit",
    "emergency",
    "enable",
    "halt",
    "import-environment",
    "isolate",
    "kexec",
    "kill",
    "link",
    "list-machines",
    "load",
    "mask",
    "preset",
    "preset-all",
    "reenable",
    "reload",
    "reload-or-restart",
    "reset-failed",
    "rescue",
    "restart",
    "revert",
    "set-default",
    "set-environment",
    "set-property",
    "start",
    "stop",
    "switch-root",
    "try-reload-or-restart",
    "try-restart",
    "unmask",
    "unset-environment"
)

[string[]] $power_commands = @(
    "hibernate",
    "hybrid-sleep",
    "poweroff",
    "reboot",
    "suspend"
)

foreach ($c in $user_commands) {
    [string] $systemwide_alias_name = "sc-$c"
    [string] $systemwide_impl = "systemctl $c"

    [string] $user_alias_name = "scu-$c"
    [string] $user_impl_body = "systemctl --user $c"

    [string] $systemwide_impl_function_name = "Invoke-Systemctl-$c"
    [string] $user_impl_function_name = "Invoke-SystemctlUser-$c"

    # Systemwide
    if (-not (Test-Path function:$systemwide_impl_function_name)) {
        [string] $user_impl_function_definition = "
function $systemwide_impl_function_name {
$systemwide_impl `@args
}"
        Invoke-Expression $user_impl_function_definition
    }
    Set-Alias -Name $systemwide_alias_name -Value $systemwide_impl_function_name -Option AllScope

    # User
    if (-not (Test-Path function:$user_impl_function_name)) {
        [string] $user_impl_function_definition = "
function $user_impl_function_name {
$user_impl_body `@args
}"
        Invoke-Expression $user_impl_function_definition
    }
    Set-Alias -Name $user_alias_name -Value $user_impl_function_name -Option AllScope
}

foreach ($c in $sudo_commands) {
    # alias "sc-$c"="sudo systemctl $c"
    # alias "scu-$c"="systemctl --user $c"
    [string] $systemwide_alias_name = "sc-$c"
    [string] $systemwide_impl = "sudo systemctl $c"

    [string] $user_alias_name = "scu-$c"
    [string] $user_impl_body = "systemctl --user $c"

    [string] $systemwide_impl_function_name = "Invoke-Systemctl-$c"
    [string] $user_impl_function_name = "Invoke-SystemctlUser-$c"

    # Systemwide
    if (-not (Test-Path function:$systemwide_impl_function_name)) {
        [string] $user_impl_function_definition = "
function $systemwide_impl_function_name {
$systemwide_impl `@args
}"
        Invoke-Expression $user_impl_function_definition
    }
    Set-Alias -Name $systemwide_alias_name -Value $systemwide_impl_function_name -Option AllScope

    # User
    if (-not (Test-Path function:$user_impl_function_name)) {
        [string] $user_impl_function_definition = "
function $user_impl_function_name {
$user_impl_body `@args
}"
        Invoke-Expression $user_impl_function_definition
    }
    Set-Alias -Name $user_alias_name -Value $user_impl_function_name -Option AllScope
}

foreach ($c in $power_commands) {
    # alias "sc-$c"="systemctl $c"

    [string] $systemwide_alias_name = "sc-$c"
    [string] $systemwide_impl = "systemctl $c"

    # Systemwide
    if (-not (Test-Path function:$systemwide_impl_function_name)) {
        [string] $user_impl_function_definition = "
function $systemwide_impl_function_name {
$systemwide_impl `@args
}"
        Invoke-Expression $user_impl_function_definition
    }
    Set-Alias -Name $systemwide_alias_name -Value $systemwide_impl_function_name -Option AllScope
}

# --now commands
function sc-enable-now {
    sc-enable --now @args
}
Set-Alias -Name sc-enable-now -Value sc-enable-now

function sc-disable-now {
    sc-disable --now @args
}
Set-Alias -Name sc-disable-now -Value sc-disable-now

function sc-mask-now {
    sc-mask --now @args
}
Set-Alias -Name sc-mask-now -Value sc-mask-now

function scu-enable-now {
    scu-enable --now @args
}
Set-Alias -Name scu-enable-now -Value scu-enable-now

function scu-disable-now {
    scu-disable --now @args
}
Set-Alias -Name scu-disable-now -Value scu-disable-now

function scu-mask-now {
    scu-mask --now @args
}
Set-Alias -Name scu-mask-now -Value scu-mask-now


Export-ModuleMember -Function * -Alias *
