#!/usr/bin/env pwsh

# TODO: write unit tests for this function.
<#
.EXAMPLE
    Format-LexicographicalDate "2025-03-06"
    Output: "Y2025 W10 03-06 Thu (D065)"
.EXAMPLE
    Format-LexicographicalDate "2024-10-13"
    Output: "Y2024 W41 10-13 Sun (D287)"
.EXAMPLE
    Format-LexicographicalDate "2023-10-11"
    Output: "Y2023 W41 10-11 Wed (D284)"
#>
Param (
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "DateTime")]
    [ValidateScript({ ($_ -is [DateTime]) -or ($_ -is [System.DateOnly]) -or ($_ -is [string] -and ([DateTime]::Parse($_) -ne $null)) }, ErrorMessage = "Input must be a DateTime or DateOnly object, or a string that is parseable as either.")]
    [object] $InputObject,

    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Now")]
    [switch] $Now
)

Begin {
    $ErrorActionPreference = "Stop"
    Set-StrictMode -Version Latest

    if ($Now) {
        $InputObject = Get-Date
    }

    if ($InputObject -is [DateTime]) {
        $date = $InputObject
    } elseif ($InputObject -is [System.DateOnly]) {
        $date = [DateTime]::new($InputObject.Year, $InputObject.Month, $InputObject.Day)
    } elseif ($InputObject -is [string]) {
        $date = [DateTime]::Parse($InputObject)
    }
}

Process {
    # output example: "Y2025 W10 03-06 Thu (D065)"

    $year = $date.Year
    # ISO 8601: week 1 is the first week with 4 or more days in the year, weeks start on Monday
    $week = [System.Globalization.CultureInfo]::InvariantCulture.Calendar.GetWeekOfYear($date, [System.Globalization.CalendarWeekRule]::FirstFourDayWeek, [System.DayOfWeek]::Monday)
    $weekPadded = $week.ToString("D2")
    $dayOfYear = $date.DayOfYear
    $dayOfWeek = $date.ToString("ddd", [System.Globalization.CultureInfo]::InvariantCulture)
    $dayOfYearPadded = $dayOfYear.ToString("D3")
    $monthPadded = $date.Month.ToString("D2")
    $dayPadded = $date.Day.ToString("D2")
    $formattedDate = "Y$year W$weekPadded $monthPadded-$dayPadded $dayOfWeek (D$dayOfYearPadded)"
    Write-Output $formattedDate
}
