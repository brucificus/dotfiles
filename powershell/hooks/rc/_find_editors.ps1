#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

try {
    # Find & configure the best text editor for this system.

    Import-Module poshy-viewer-finder -DisableNameChecking
    [System.Collections.Generic.List[string[]]] $text_editor_search_parameterizations = [System.Collections.Generic.List[string[]]]::new()
    $text_editor_search_parameterizations.Add(@("-App_Is_VSCode", "-StayInTerminal"))
    $text_editor_search_parameterizations.Add(@("-EditingAllowed", "-ShowLineNumbers", "-TextContentSyntaxHighlight", "-StayInTerminal"))
    $text_editor_search_parameterizations.Add(@("-App_Is_VSCode"))
    $text_editor_search_parameterizations.Add(@("-EditingAllowed", "-ShowLineNumbers", "-TextContentSyntaxHighlight"))
    $text_editor_search_parameterizations.Add(@("-EditingAllowed", "-ShowLineNumbers", "-TextContentPlain"))
    $text_editor_search_parameterizations.Add(@("-EditingAllowed", "-TextContentPlain"))
    $text_editor_search_parameterizations.Add(@("-EditingAllowed"))

    [object[]] $text_editors_generic = for ($i = 0; $i -lt $text_editor_search_parameterizations.Count; $i++) {
        $text_editor_search_parameterization = $text_editor_search_parameterizations[$i]
        Invoke-Expression "Get-Viewer $text_editor_search_parameterization" | Select-Object -First 1
    }

    [object[]] $text_editors_guiwaiting = for ($i = 0; $i -lt $text_editor_search_parameterizations.Count; $i++) {
        $text_editor_search_parameterization = $text_editor_search_parameterizations[$i]
        Invoke-Expression "Get-Viewer $text_editor_search_parameterization -TerminalWaitsUntilExit" | Select-Object -First 1
    }
    $text_editors_guiwaiting += @($text_editors_generic)

    [string[]] $text_editor_generic_bins = (
        $text_editors_generic `
        | Select-Object -ExpandProperty Bin `
        | Get-Item -ErrorAction SilentlyContinue `
        | Select-Object -ExpandProperty BaseName
    )
    [object] $text_editor_generic = ($text_editors_generic | Select-Object -First 1)
    [object] $text_editor_guiwaiting = ($text_editors_guiwaiting | Select-Object -First 1)

    if ($text_editor_generic_bins -notcontains "code") {
        append_profile_suggestions "# TODO: 🧑‍💻 Install VSCode. See: https://code.visualstudio.com/docs/setup/linux."
    }

    if ($text_editor_generic_bins -notcontains "nano") {
        append_profile_suggestions "# TODO: ⌨️ Install 'nano'."
    }

    if (($null -eq $text_editor_generic) -or ($null -eq $text_editor_guiwaiting)) {
        append_profile_suggestions "# TODO: 🧑‍💻 Install a text editor."
        Remove-EnvVar -Process -Name EDITOR -ErrorAction SilentlyContinue
        Remove-EnvVar -Process -Name VISUAL -ErrorAction SilentlyContinue
    } else {
        Set-EnvVar -Process -Name EDITOR -Value ($text_editor_guiwaiting | Format-ViewerInvocationSh)
        Set-EnvVar -Process -Name VISUAL -Value $Env:EDITOR

        $text_editor_generic | New-ViewerInvocationFunction -FunctionName edit
    }


    # Find & configure a binary editor for this sytem.

    [object[]] $binary_editors = @(Get-Viewer -EditingAllowed -BinaryContentBlob)

    if ($binary_editors.Count -eq 0) {
        append_profile_suggestions "# TODO: 🧑‍💻 Install a binary editor."
        Remove-EnvVar -Process -Name EDITORB -ErrorAction SilentlyContinue
        return
    } else {
        [object] $binary_editor = $binary_editors[0]
        Set-EnvVar -Process -Name EDITORB -Value ($binary_editor | Format-ViewerInvocationSh)

        $binary_editor | New-ViewerInvocationFunction -FunctionName editb
    }
} finally {
    Remove-Variable -Name binary_editor -ErrorAction SilentlyContinue
    Remove-Variable -Name binary_editors -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editor_generic -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editor_generic_bins -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editor_guiwaiting -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editor_search_parameterization -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editor_search_parameterizations -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editors_generic -ErrorAction SilentlyContinue
    Remove-Variable -Name text_editors_guiwaiting -ErrorAction SilentlyContinue
}
