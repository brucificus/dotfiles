#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not $IsWindows) {
    return
}

if (-not (Test-SessionInteractivity)) {
    return
}

try {
    $vs_yearskus=@(
        @{year=2022;sku="Enterprise"}
        @{year=2022;sku="Professional"}
        @{year=2022;sku="Community"}
        @{year=2022;sku="BuildTools"}

        @{year=2019;sku="Enterprise"}
        @{year=2019;sku="Professional"}
        @{year=2019;sku="Community"}
        @{year=2019;sku="BuildTools"}

        @{year=2017;sku="Enterprise"}
        @{year=2017;sku="Professional"}
        @{year=2017;sku="Community"}
        @{year=2017;sku="BuildTools"}
    )

    [string] $programfiles_vs="$Env:ProgramFiles\Microsoft Visual Studio\"
    if (Test-Path -ErrorAction SilentlyContinue "$programfiles_vs") {
        foreach ($vs in $vs_yearskus) {
            $vs_year=$vs.year
            $vs_sku=$vs.sku
            $currModulePath = "$programfiles_vs\$vs_year\$vs_sku\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
            # Prior to 16.3 the DevShell module was in a different location
            $prevModulePath = "$programfiles_vs\$vs_year\$vs_sku\Common7\Tools\vsdevshell\Microsoft.VisualStudio.DevShell.dll"
            $devshell_dll = if (Test-Path $prevModulePath -ErrorAction SilentlyContinue) { $prevModulePath } else { $currModulePath }


            if (Test-Path -ErrorAction SilentlyContinue "$devshell_dll") {
                Import-Module $devshell_dll -Global
                function Enter-VsDevShellDefault() {
                    Enter-VsDevShell -VsInstallPath "$programfiles_vs\$vs_year\$vs_sku" -SkipAutomaticLocation @args
                }
                Set-Alias -Name vsdevshell -Value Enter-VsDevShellDefault

                break
            }
        }
    }
} finally {
    Remove-Variable -Name currModulePath -ErrorAction SilentlyContinue
    Remove-Variable -Name devshell_dll -ErrorAction SilentlyContinue
    Remove-Variable -Name prevModulePath -ErrorAction SilentlyContinue
    Remove-Variable -Name programfiles_vs -ErrorAction SilentlyContinue
    Remove-Variable -Name vs -ErrorAction SilentlyContinue
    Remove-Variable -Name vs_sku -ErrorAction SilentlyContinue
    Remove-Variable -Name vs_year -ErrorAction SilentlyContinue
    Remove-Variable -Name vs_yearskus -ErrorAction SilentlyContinue
}
