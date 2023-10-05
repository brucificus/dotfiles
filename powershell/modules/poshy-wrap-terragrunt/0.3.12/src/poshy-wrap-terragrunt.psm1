#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Invoke-Terragrunt {
    terragrunt @args
}
Set-Alias -Name tg -Value Invoke-Terragrunt

function Invoke-TerragruntValidate {
    terragrunt validate @args
}
Set-Alias -Name tgv -Value Invoke-TerragruntValidate

function Invoke-TerragruntPlan {
    terragrunt plan @args
}
Set-Alias -Name tgp -Value Invoke-TerragruntPlan

function Invoke-TerragruntApply {
    terragrunt apply @args
}
Set-Alias -Name tga -Value Invoke-TerragruntApply

function Invoke-TerragruntDestroy {
    terragrunt destroy @args
}
Set-Alias -Name tgd -Value Invoke-TerragruntDestroy

function Invoke-TerragruntValidateAll {
    terragrunt validate-all @args
}
Set-Alias -Name tgva -Value Invoke-TerragruntValidateAll

function Invoke-TerragruntPlanAll {
    terragrunt plan-all @args
}
Set-Alias -Name tgpa -Value Invoke-TerragruntPlanAll

function Invoke-TerragruntApplyAll {
    terragrunt apply-all @args
}
Set-Alias -Name tgaa -Value Invoke-TerragruntApplyAll

function Invoke-TerragruntDestroyAll {
    terragrunt destroy-all @args
}
Set-Alias -Name tgda -Value Invoke-TerragruntDestroyAll


Export-ModuleMember -Function * -Alias *
