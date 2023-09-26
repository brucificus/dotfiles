#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Invoke-VaultDelete {
    vault delete @args
}
Set-Alias -Name vad -Value Invoke-VaultDelete

function Invoke-VaultList {
    vault list @args
}
Set-Alias -Name val -Value Invoke-VaultList

function Invoke-VaultRead {
    vault read @args
}
Set-Alias -Name var -Value Invoke-VaultRead

function Invoke-VaultRenew {
    vault renew @args
}
Set-Alias -Name varn -Value Invoke-VaultRenew

function Invoke-VaultRevoke {
    vault revoke @args
}
Set-Alias -Name varv -Value Invoke-VaultRevoke

function Invoke-VaultServer {
    vault server @args
}
Set-Alias -Name vasrv -Value Invoke-VaultServer

function Invoke-VaultStatus {
    vault status @args
}
Set-Alias -Name vas -Value Invoke-VaultStatus

function Invoke-VaultVersion {
    vault version @args
}
Set-Alias -Name vav -Value Invoke-VaultVersion

function Invoke-VaultWrite {
    vault write @args
}
Set-Alias -Name vaw -Value Invoke-VaultWrite

function Invoke-VaultLoginViaGithub {
    vault login -method=github @args
}
Set-Alias -Name vag -Value Invoke-VaultLoginViaGithub

function Invoke-VaultReadFieldValue {
    vault read -field=value @args
}
Set-Alias -Name varv -Value Invoke-VaultReadFieldValue


Export-ModuleMember -Function * -Alias *
