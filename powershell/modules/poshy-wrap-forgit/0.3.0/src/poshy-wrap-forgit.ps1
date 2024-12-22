#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


# Functions for wrapping forgit.
function forgit-log {
    forgit log @args
}

function forgit-diff {
    forgit diff @args
}

function forgit-add {
    forgit add @args
}

function forgit-reset-head {
    forgit reset_head @args
}

function forgit-stash-show {
    forgit stash_show @args
}

function forgit-stash-push {
    forgit stash_push @args
}

function forgit-clean {
    forgit clean @args
}

function forgit-cherry-pick {
    forgit cherry_pick @args
}

function forgit-cherry-pick-from-branch {
    forgit cherry_pick_from_branch @args
}

function forgit-rebase {
    forgit rebase @args
}

function forgit-fixup {
    forgit fixup @args
}

function forgit-checkout-file {
    forgit checkout_file @args
}

function forgit-checkout-branch {
    forgit checkout_branch @args
}

function forgit-checkout-tag {
    forgit checkout_tag @args
}

function forgit-checkout-commit {
    forgit checkout_commit @args
}

function forgit-branch-delete {
    forgit branch_delete @args
}

function forgit-revert-commit {
    forgit revert_commit @args
}

function forgit-blame {
    forgit blame @args
}

function forgit-ignore {
    forgit ignore @args
}

function forgit-ignore-update {
    forgit ignore_update @args
}

function forgit-ignoreget() {
    forgit ignore_get @args
}

function forgit-ignore-list {
    forgit ignore_list @args
}

function forgit-ignore-clean {
    forgit ignore_clean @args
}

$forgit_add = ($Env:forgit_add ?? "ga")
$forgit_reset_head = ($Env:forgit_reset_head ?? "grh")
$forgit_log = ($Env:forgit_log ?? "glo")
$forgit_diff = ($Env:forgit_diff ?? "gd")
$forgit_ignore = ($Env:forgit_ignore ?? "gi")
$forgit_checkout_file = ($Env:forgit_checkout_file ?? "gcf")
$forgit_checkout_branch = ($Env:forgit_checkout_branch ?? "gcb")
$forgit_checkout_commit = ($Env:forgit_checkout_commit ?? "gco")
$forgit_checkout_tag = ($Env:forgit_checkout_tag ?? "gct")
$forgit_branch_delete = ($Env:forgit_branch_delete ?? "gbd")
$forgit_revert_commit = ($Env:forgit_revert_commit ?? "grc")
$forgit_clean = ($Env:forgit_clean ?? "gclean")
$forgit_stash_show = ($Env:forgit_stash_show ?? "gss")
$forgit_stash_push = ($Env:forgit_stash_push ?? "gsp")
$forgit_cherry_pick = ($Env:forgit_cherry_pick ?? "gcp")
$forgit_rebase = ($Env:forgit_rebase ?? "grb")
$forgit_fixup = ($Env:forgit_fixup ?? "gfu")
$forgit_blame = ($Env:forgit_blame ?? "gbl")

Set-Alias -Name $forgit_add -Value forgit-add
Set-Alias -Name $forgit_reset_head -Value forgit-reset-head
Set-Alias -Name $forgit_log -Value forgit-log
Set-Alias -Name $forgit_diff -Value forgit-diff
Set-Alias -Name $forgit_ignore -Value forgit-ignore
Set-Alias -Name $forgit_checkout_file -Value forgit-checkout-file
Set-Alias -Name $forgit_checkout_branch -Value forgit-checkout-branch
Set-Alias -Name $forgit_checkout_commit -Value forgit-checkout-commit
Set-Alias -Name $forgit_checkout_tag -Value forgit-checkout-tag
Set-Alias -Name $forgit_branch_delete -Value forgit-branch-delete
Set-Alias -Name $forgit_revert_commit -Value forgit-revert-commit
Set-Alias -Name $forgit_clean -Value forgit-clean
Set-Alias -Name $forgit_stash_show -Value forgit-stash-show
Set-Alias -Name $forgit_stash_push -Value forgit-stash-push
Set-Alias -Name $forgit_cherry_pick -Value forgit-cherry-pick-from-branch
Set-Alias -Name $forgit_rebase -Value forgit-rebase
Set-Alias -Name $forgit_fixup -Value forgit-fixup
Set-Alias -Name $forgit_blame -Value forgit-blame


Export-ModuleMember -Function * -Alias *
