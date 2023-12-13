#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


try {
    phook_enqueue_module "poshy-multimedia"

    [bool] $imageMagickInstalled = (Test-Command convert) -and (
        (convert --version 2> $null) -like "*ImageMagick*"
    )
    if ($imageMagickInstalled) {
        # Intentionally left blank.
    } else {
        append_profile_suggestions "# TODO: ⚙️ Add 'convert' (from ImageMagick) to your PATH."
    }

    if (-not (Test-Command catimg)) {
        append_profile_suggestions "# TODO: 🖼️ Install 'catimg'. See: https://github.com/posva/catimg#installation."
    }

    if (-not (Test-Command asciinema)) {
        append_profile_suggestions "# TODO: 📽️ Install 'asciinema'. See: https://github.com/asciinema/asciinema#quick-intro."
    }

    if (Test-Command universalarchive) {
        Set-Alias -Name ua -Value universalarchive
    }

    if (Test-Command jq) {
        if (Test-Command fzf) {
            # Intentionally left blank.
        } else {
            append_profile_suggestions "# TODO: 🔎 Install 'fzf'. See: https://github.com/junegunn/fzf#installation."
        }
    } else {
        append_profile_suggestions "# TODO: 📝 Install 'jq'. See: https://jqlang.github.io/jq/download/."
    }


    if (Test-Command fzf) {
        # Intentionally left blank.
    } elseif (-not (Test-Command jq)) {
        append_profile_suggestions "# TODO: 🔎 Install 'fzf'. See: https://github.com/junegunn/fzf#installation."
    }

    if ((Test-Command jq) -and (-not (Test-Command yq))) {
        append_profile_suggestions "# TODO: 📝 Install 'yq'. See: https://github.com/mikefarah/yq#install."
    }

    if ($IsWindows -or (Test-Command mkisofs) -or (Test-Command genisoimage)) {
        Set-Alias -Name mkiso -Value New-IsoFile
    } else {
        append_profile_suggestions "# TODO: 📀 Install 'mkisofs' or 'genisoimage'. See: https://wiki.debian.org/genisoimage."
    }
} finally {
    Remove-Variable -Name imageMagickInstalled -ErrorAction SilentlyContinue
}
