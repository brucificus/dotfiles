#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Invoke-Terraform {
    terraform @args
}
Set-Alias -Name tf -Value Invoke-Terraform

function Invoke-TerraformInit {
    terraform init @args
}
Set-Alias -Name tfi -Value Invoke-TerraformInit

function Invoke-TerraformValidate {
    terraform validate @args
}
Set-Alias -Name tfv -Value Invoke-TerraformValidate

function Invoke-TerraformPlan {
    terraform plan @args
}
Set-Alias -Name tfp -Value Invoke-TerraformPlan

function Invoke-TerraformApply {
    terraform apply @args
}
Set-Alias -Name tfa -Value Invoke-TerraformApply

function Invoke-TerraformDestroy {
    terraform destroy @args
}
Set-Alias -Name tfd -Value Invoke-TerraformDestroy

function Invoke-TerraformConsole {
    terraform console @args
}
Set-Alias -Name tfc -Value Invoke-TerraformConsole

function Invoke-TerraformFormat {
    terraform fmt @args
}
Set-Alias -Name tff -Value Invoke-TerraformFormat

function Invoke-TerraformOutput {
    terraform output @args
}
Set-Alias -Name tfo -Value Invoke-TerraformOutput


Export-ModuleMember -Function * -Alias *
