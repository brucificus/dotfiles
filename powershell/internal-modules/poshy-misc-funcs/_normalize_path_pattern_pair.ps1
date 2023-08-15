#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


# Takes a path and a pattern and normalizes them such that the output path is the longest non-globbing prefix of the concatenated inputs and the output pattern is the remaining portion of the concatenated inputs.
function _normalize_path_pattern_pair {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $start_path,

        [Parameter(Mandatory = $false, Position = 1)]
        [string] $start_pattern = ""
    )
    [string] $result_path = $start_path
    [string] $result_pattern = $start_pattern
    [string] $chunk_to_move = ""

    # Move parts from the end of the path to the beginning of the pattern until the path doesn't contain globs.
    while (($result_path -ne ".") -and (_has_glob $result_path)) {
        $chunk_to_move = (basename $result_path)
        $result_path = (dirname_bin $result_path)
        $result_pattern = (Join-Path $chunk_to_move $result_pattern)
    }

    [string] $ds = [System.IO.Path]::DirectorySeparatorChar
    # Move non-globs from the beginning of the pattern to the end of the path.
    while ($result_pattern -like "*${ds}*") {
        [int] $firstDsIndex = $result_pattern.IndexOf($ds)
        $chunk_to_move = $result_pattern.Substring(0, $firstDsIndex)

        if (_has_glob "$chunk_to_move") {
            break
        }

        $result_pattern = $result_pattern.Substring($firstDsIndex + 1)
        $result_path = (Join-Path $result_path $chunk_to_move)
    }

    # If the pattern starts with './', remove it.
    if ($result_pattern -like ".${ds}*") {
        $result_path = (Join-Path $result_path ".{$ds}")
        $result_pattern = $result_pattern.Substring(2)
    }

    # Make sure the pattern always has something in it.
    if (-not $result_pattern) {
        $result_pattern = (basename $result_path)
        $result_path = (dirname $result_path)
    }

    return [PSCustomObject]@{
        Path = $result_path
        Pattern = $result_pattern
    }
}
