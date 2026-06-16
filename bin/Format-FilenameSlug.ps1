#!/usr/bin/env pwsh

# TODO: see https://github.com/brucificus/onenote-to-markdown/blob/main/path_scrubbing/PathComponentScrubber.py#L101
# TODO: write unit tests for this function.
<#
.EXAMPLE
    Format-FilenameSlug "[bLUBBERguts] Endpoint: GET noun1/noun2/:noun3/noun4"
    Output: "[bLUBBERguts] Endpoint˸ GET noun1∕noun2∕˸noun3∕noun4"
#>
Param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [string] $InputObject
)

Begin {
    $ErrorActionPreference = "Stop"
    Set-StrictMode -Version Latest

    $characterReplacementMap = [ordered]@{
        '<'  = '＜'
        '>'  = '＞'
        ':'  = '˸'
        '"'  = '＂'
        '/'  = '∕'
        '\\' = '＼'
        '|'  = '｜'
        '?'  = '？'
        '*'  = '＊'
    }
}

Process {
    $cleaned = $InputObject -replace '[\x00-\x1F]', ''

    foreach ($entry in $characterReplacementMap.GetEnumerator()) {
        $cleaned = $cleaned -replace [Regex]::Escape($entry.Key), $entry.Value
    }

    # Windows disallows path components with trailing spaces or periods.
    $cleaned = $cleaned.TrimEnd(' ', '.')

    Write-Output $cleaned
}
