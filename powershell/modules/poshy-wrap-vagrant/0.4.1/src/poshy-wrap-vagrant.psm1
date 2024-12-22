#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Invoke-VagrantHostsList {
    vagrant hosts list @args
}
Set-Alias -Name vhl -Value Invoke-VagrantHostsList

function Invoke-VagrantScp {
    vagrant scp @args
}
Set-Alias -Name vscp -Value Invoke-VagrantScp

function Invoke-VagrantSnapshotList {
    vagrant snapshot list @args
}
Set-Alias -Name vsl -Value Invoke-VagrantSnapshotList

function Invoke-VagrantSnapshotTake {
    vagrant snapshot take @args
}
Set-Alias -Name vst -Value Invoke-VagrantSnapshotTake

function Invoke-VagrantUp {
    vagrant up @args
}
Set-Alias -Name vup -Value Invoke-VagrantUp

function Invoke-VagrantUpLogged {
    vagrant up 2>&1 | tee vagrant.log
}
Set-Alias -Name vupl -Value Invoke-VagrantUpLogged

function Invoke-VagrantHalt {
    vagrant halt @args
}
Set-Alias -Name vh -Value Invoke-VagrantHalt

function Invoke-VagrantSuspend {
    vagrant suspend @args
}
Set-Alias -Name vs -Value Invoke-VagrantSuspend

function Invoke-VagrantResume {
    vagrant resume @args
}
Set-Alias -Name vr -Value Invoke-VagrantResume

function Invoke-VagrantReload {
    vagrant reload @args
}
Set-Alias -Name vrl -Value Invoke-VagrantReload

function Invoke-VagrantSsh {
    vagrant ssh @args
}
Set-Alias -Name vssh -Value Invoke-VagrantSsh

function Invoke-VagrantStatus {
    vagrant status @args
}
Set-Alias -Name vst -Value Invoke-VagrantStatus

function Invoke-VagrantProvision {
    vagrant provision @args
}
Set-Alias -Name vp -Value Invoke-VagrantProvision

function Invoke-VagrantDestroy {
    vagrant destroy @args
}
Set-Alias -Name vdstr -Value Invoke-VagrantDestroy

# requires vagrant-list plugin
function Invoke-VagrantList {
    vagrant list @args
}
Set-Alias -Name vl -Value Invoke-VagrantList

# requires vagrant-hostmanager plugin
function Invoke-VagrantHostmanager {
    vagrant hostmanager @args
}
Set-Alias -Name vhst -Value Invoke-VagrantHostmanager


Export-ModuleMember -Function * -Alias *
