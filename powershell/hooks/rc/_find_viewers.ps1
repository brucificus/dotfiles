#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.5.22"}
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


try {
    # Find & configure viewers for text files and binary files on this system.

    Set-EnvVar -Process -Name BAT_THEME -Value "ansi-dark"


    #
    # Find & configure a text viewer.
    #

    [object[]] $text_viewers = @() + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentSyntaxHighlight -StayInTerminal -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentSyntaxHighlight -StayInTerminal) + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentSyntaxHighlight) + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentPlain -StayInTerminal -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentPlain -StayInTerminal) + `
        (Get-Viewer -ReadOnly -ShowLineNumbers -TextContentPlain) + `
        (Get-Viewer -ReadOnly -TextContentPlain) + `
        (Get-Viewer -ReadOnly)
    [string[]] $text_viewer_bins = (
        $text_viewers `
        | Select-Object -ExpandProperty Bin `
        | Get-Item -ErrorAction SilentlyContinue `
        | Select-Object -ExpandProperty BaseName
    )
    [object] $text_viewer = ($text_viewers | Select-Object -First 1)

    if ($text_viewer_bins -notcontains "batcat") {
        append_profile_suggestions "# TODO: 🦇🐈 Install 'batcat'."
    }

    if ($text_viewer_bins -notcontains "pygmentize") {
        append_profile_suggestions "# TODO: 🌈 Install \`Pygments\`. See: https://pygments.org/download/."
    }

    if ($null -eq $text_viewer) {
        append_profile_suggestions "# TODO: 🪟 Install a text viewer."
        Remove-EnvVar -Process -Name VIEWER -ErrorAction SilentlyContinue
    } else {
        Set-EnvVar -Process -Name VIEWER -Value ($text_viewer | Format-ViewerInvocationSh)
        $text_viewer | New-ViewerInvocationFunction -FunctionName view
    }


    #
    # Find & configure a binary viewer.
    #

    [object[]] $binary_viewers = @() + `
        (Get-Viewer -ReadOnly -BinaryContentBlob -StayInTerminal) + `
        (Get-Viewer -ReadOnly -BinaryContentBlob)
    [string[]] $binary_viewer_bins = (
        $binary_viewers `
        | Select-Object -ExpandProperty Bin `
        | Get-Item -ErrorAction SilentlyContinue `
        | Select-Object -ExpandProperty BaseName
    )
    [object] $binary_viewer = ($binary_viewers | Select-Object -First 1)

    if ($binary_viewer_bins -notcontains "hexdump") {
        append_profile_suggestions "# TODO: 🔢 Install 'hexdump'."
    }

    if ($null -eq $binary_viewer) {
        append_profile_suggestions "# TODO: 🔢 Install a binary viewer."
        Remove-EnvVar -Process -Name VIEWERB -ErrorAction SilentlyContinue
    } else {
        Set-EnvVar -Process -Name VIEWERB -Value ($binary_viewer | Format-ViewerInvocationSh)
        $binary_viewer | New-ViewerInvocationFunction -FunctionName viewb
    }


    #
    # Find & configure LESS.
    #

    Remove-EnvVar -Process -NameLike LESS* -ErrorAction SilentlyContinue
    [object] $text_pager_less_proper = Get-Viewer -App_Is_Less -NoLineNumbers
    [object[]] $text_pagers_less = @() + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain) + `
        @($text_pager_less_proper) `
        | Where-Object { $_.NeverPages -eq $false }
    if ($text_pagers_less -and $text_pager_less_proper) {
        [object] $text_pager_less_preferred = ($text_pagers_less | Select-Object -First 1)

        # Setup the 'less' environment variable, for apps that call 'less' directly.
        # This 'inner' pager should always have line numbers disabled, because the outer pager is responsible for those.
        [object] $text_pagers_underlying_less_actual = $text_pagers_less `
            | Where-Object { $_.Id -like "less#*" -and $_.ShowLineNumbers -eq $false } `
            | Select-Object -First 1
        Set-EnvVar -Process -Name LESS -Value $text_pagers_underlying_less_actual.BinArgs

        # TODO: LESSOPEN, LESSCLOSE. lesspipe?

        # Setup the 'less' alias function.
        if ($text_pager_less_preferred.Id -like "bat*") {
            $text_pager_less_preferred.BinArgs += @('--pager', ($text_pagers_underlying_less_actual | Format-ViewerInvocationSh))
        }
        $text_pager_less_preferred | New-ViewerInvocationFunction -FunctionName less -Force
    } else {
        append_profile_suggestions "# TODO: 📄 Install 'less'."
    }


    #
    # Find & configure MORE.
    #

    Remove-EnvVar -Process -NameLike MORE* -ErrorAction SilentlyContinue
    [object] $text_pager_more_proper = Get-Viewer -App_Is_More -NoLineNumbers
    [object[]] $text_pagers_more = @() + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -AlwaysPages -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentSyntaxHighlight -AlwaysPages) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -AlwaysPages -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -TextContentPlain -AlwaysPages) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -AlwaysPages -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentSyntaxHighlight -AlwaysPages) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -AlwaysPages -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -ShowLineNumbers -TextContentPlain -AlwaysPages) + `
        @($text_pager_more_proper) `
        | Where-Object { $_.NeverPages -eq $false }
    if ($text_pagers_more) {
        [object] $text_pager_more_preferred = ($text_pagers_more | Select-Object -First 1)

        # Setup the 'more' environment variable, for apps that call 'more' directly.
        # This 'inner' pager should always have line numbers disabled, because the outer pager is responsible for those.
        [object] $text_pagers_underlying_more_actual = $text_pagers_more `
            | Where-Object { $_.Id -like "more#*" -and $_.ShowLineNumbers -eq $false } `
            | Select-Object -First 1
        Set-EnvVar -Process -Name MORE -Value $text_pagers_underlying_more_actual.BinArgs

        # Setup the 'more' alias function.
        if ($text_pager_more_preferred.Id -like "bat*") {
            $text_pager_more_preferred.BinArgs += @('--pager', ($text_pagers_underlying_more_actual | Format-ViewerInvocationSh))
        }
        $text_pager_more_preferred | New-ViewerInvocationFunction -FunctionName more -Force
    } else {
        append_profile_suggestions "# TODO: 📃 Install 'more'."
    }


    #
    # Configure PAGER.
    #

    [object[]] $pager_candidates = @() + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -ShortPageEarlyExit -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -AnsiPassThru) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers -ShortPageEarlyExit) + `
        (Get-Viewer -ReadOnly -StayInTerminal -AcceptsInputPiped -NoLineNumbers) + `
        @($text_pager_less_proper, $text_pager_more_proper) `
        | Where-Object { $_.NeverPages -eq $false }
    if (-not $pager_candidates) {
        append_profile_suggestions "# TODO: 📄 Install a pager."
        return
    }
    [object] $pager_preferred = ($pager_candidates | Select-Object -First 1)

    [hashtable] $pager_env = @{}
    if ($text_pager_less_proper) {
        if ($pager_preferred.Id -like "less#*") {
            $pager_env['LESS'] = $pager_preferred.BinArgs
        } elseif ($pager_preferred.Id -like "bat*") {
            [object] $pager_underlying_less_actual = $pager_candidates `
                | Where-Object { $_.Id -like "less#*" -and $_.ShowLineNumbers -eq $false } `
                | Select-Object -First 1
            $pager_env['PAGER'] = $pager_underlying_less_actual.Bin
            $pager_preferred.BinArgs += @(
                '--pager', ($pager_underlying_less_actual | Format-ViewerInvocationSh)
            )

            $pager_env['LESS'] = $pager_underlying_less_actual.BinArgs
        }
    } elseif ($text_pager_more_proper) {
        if ($pager_preferred.Id -like "more#*") {
            $pager_env['MORE'] = $pager_preferred.BinArgs
        } elseif ($pager_preferred.Id -like "bat*") {
            [object] $pager_underlying_more_actual = $pager_candidates `
                | Where-Object { $_.Id -like "more#*" -and $_.ShowLineNumbers -eq $false } `
                | Select-Object -First 1
            $pager_env['PAGER'] = $pager_underlying_more_actual.Bin
            $pager_preferred.BinArgs += @(
                '--pager', ($pager_underlying_more_actual | Format-ViewerInvocationSh)
            )
            $pager_env['MORE'] = $pager_underlying_more_actual.BinArgs
        }
    }
    if ($pager_env['LESS']) {
        # Stylization choices originate from …/oh-my-zsh/…/colored-man-pages.plugin.zsh
        [hashtable] $less_env = `
            Format-LessTermcapEnv `
                -NaiveDefaults `
                -BlinkOn (fmtBold (fgRed)) `
                -BoldOn (fmtBold (fgRed)) `
                -BoldOffBlinkOffUnderlineOff (fmtReset) `
                -StandoutOn (fmtBold (fgYellow) (bgBlue)) `
                -StandoutOff (fmtReset) `
                -UnderlineOn (fmtBold (fgGreen)) `
                -UnderlineOff (fmtReset)
        $pager_env += $less_env

        # TODO: LESSOPEN, LESSCLOSE, lesspipe?
    }
    # TODO: Integrate $pager_env into Format-ViewerInvocationSh.
    Set-EnvVar -Process -Name PAGER -Value ($pager_candidates | Select-Object -First 1 | Format-ViewerInvocationSh)


    #
    # Find & configure a MANPAGER.
    #

    if (-not $IsLinux) {
        return
    }

    [object] $manpager_preferred = $pager_preferred

    [hashtable] $manpager_env = @{}
    if ($text_pager_less_proper) {
        if ($manpager_preferred.Id -like "less#*") {
            $manpager_env['LESS'] = $manpager_preferred.BinArgs
        } elseif ($manpager_preferred.Id -like "bat*") {
            [object] $manpager_underlying_less_actual = $pager_candidates `
                | Where-Object { $_.Id -like "less#*" -and $_.ShowLineNumbers -eq $false } `
                | Select-Object -First 1
            # $manpager_env['PAGER'] = $manpager_underlying_less_actual.Bin
            # $manpager_preferred.BinArgs += @(
            #     '--pager', ($manpager_underlying_less_actual | Format-ViewerInvocationSh)
            # )
            $manpager_env['LESS'] = $manpager_underlying_less_actual.BinArgs
        }
    } elseif ($text_pager_more_proper) {
        if ($manpager_preferred.Id -like "more#*") {
            $manpager_env['MORE'] = $manpager_preferred.BinArgs
        } elseif ($manpager_preferred.Id -like "bat*") {
            [object] $manpager_underlying_more_actual = $pager_candidates `
                | Where-Object { $_.Id -like "more#*" -and $_.ShowLineNumbers -eq $false } `
                | Select-Object -First 1
            # $manpager_env['PAGER'] = $manpager_underlying_more_actual.Bin
            # $manpager_preferred.BinArgs += @(
            #     '--pager', ($manpager_underlying_more_actual | Format-ViewerInvocationSh)
            # )
            $manpager_env['MORE'] = $manpager_underlying_more_actual.BinArgs
        }
    }
    Remove-Variable -Name pager_candidates
    if ($manpager_preferred.Id -like "bat*") {
        $manpager_preferred.BinArgs += @(
            '-l', 'man'
        )
    }
    if ($manpager_env['LESS']) {
        # Stylization choices originate from …/oh-my-zsh/…/colored-man-pages.plugin.zsh
        [hashtable] $less_env = `
            Format-LessTermcapEnv `
                -NaiveDefaults `
                -BlinkOn (fmtBold (fgRed)) `
                -BoldOn (fmtBold (fgRed)) `
                -BoldOffBlinkOffUnderlineOff (fmtReset) `
                -StandoutOn (fmtBold (fgYellow) (bgBlue)) `
                -StandoutOff (fmtReset) `
                -UnderlineOn (fmtBold (fgGreen)) `
                -UnderlineOff (fmtReset)
        $manpager_env += $less_env

        # TODO: LESSOPEN, LESSCLOSE, lesspipe?
    }

    # TODO: Integrate $manpager_env into Format-ViewerInvocationSh.
    [string] $manpager_innermost_command = ($manpager_preferred | Format-ViewerInvocationSh)
    [string] $manpager_midlevel_command = "col -bx | $manpager_innermost_command"
    [string] $manpager_outer_command = "sh -c `"$manpager_midlevel_command`""
    Set-EnvVar -Process -Name MANPAGER -Value $manpager_outer_command

    $manpager_env = $manpager_env.Clone()
    $manpager_env['MANPAGER'] = $manpager_outer_command


    #
    # Alias functions for man and dman/debman (from debian-goodies)
    #

    # TODO: Change these names back after differential debugging is done. (remove the 'x')
    $man_bin = Search-CommandPath "man" -ErrorAction SilentlyContinue
    if ($man_bin) {
        function xman {
            param(
                [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
                [ValidateNotNullOrEmpty()]
                [string[]] $keywords
            )
            xwith $manpager_env { &$man_bin @keywords }.GetNewClosure()
        }
    }

    $dman_bin = Search-CommandPath "dman" -ErrorAction SilentlyContinue
    if ($dman_bin) {
        function xdman {
            param(
                [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
                [ValidateNotNullOrEmpty()]
                [string[]] $keywords
            )
            xwith $manpager_env { &$dman_bin @keywords }.GetNewClosure()
        }
    }

    $debman_bin = Search-CommandPath "debman" -ErrorAction SilentlyContinue
    if ($debman_bin) {
        function xdebman {
            param(
                [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
                [ValidateNotNullOrEmpty()]
                [string[]] $keywords
            )
            xwith $manpager_env { &$debman_bin @keywords }.GetNewClosure()
        }
    }
} finally {
    Remove-Variable -Name binary_viewer -ErrorAction SilentlyContinue
    Remove-Variable -Name binary_viewer_bins -ErrorAction SilentlyContinue
    Remove-Variable -Name binary_viewers -ErrorAction SilentlyContinue
    Remove-Variable -Name manpager_env -ErrorAction SilentlyContinue
    Remove-Variable -Name manpager_innermost_command -ErrorAction SilentlyContinue
    Remove-Variable -Name manpager_midlevel_command -ErrorAction SilentlyContinue
    Remove-Variable -Name manpager_outer_command -ErrorAction SilentlyContinue
    Remove-Variable -Name manpager_preferred -ErrorAction SilentlyContinue
    Remove-Variable -Name pager_candidates -ErrorAction SilentlyContinue
    Remove-Variable -Name pager_env -ErrorAction SilentlyContinue
    Remove-Variable -Name pager_preferred -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pager_less_proper -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pager_more_preferred -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pager_more_proper -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pagers_less -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pagers_more -ErrorAction SilentlyContinue
    Remove-Variable -Name text_pagers_underlying_more_actual -ErrorAction SilentlyContinue
    Remove-Variable -Name text_viewer -ErrorAction SilentlyContinue
    Remove-Variable -Name text_viewer_bins -ErrorAction SilentlyContinue
    Remove-Variable -Name text_viewers -ErrorAction SilentlyContinue
}
