#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (Test-Command java) {
    <#
    .SYNOPSIS
        Extracts the specified JAR file's MANIFEST file and prints it to stdout.
    .PARAMETER jarFile
    .EXAMPLE
        jar_manifest lib/foo.jar
    .COMPONENT
        java
    #>
    function jar_manifest {
        param(
            [Parameter(Mandatory=$true, Position=0)]
            [ValidateNotNullOrEmpty()]
            [string] $jarFile
        )
        unzip -c $jarFile META-INF/MANIFEST.MF
    }
} else {
    append_profile_suggestions "# TODO: ☕ Install the OpenJDK. See: https://openjdk.org/install/."
}

if (Test-Command maven) {
    phook_enqueue_module "poshy-wrap-maven"
} elseif (Test-Command java) {
    append_profile_suggestions "# TODO: ☕ Install Apache Maven. See: https://maven.apache.org/install.html."
}

if (Test-Command gradle) {
    # Intentionally left blank.
} elseif (Test-Command java) {
    append_profile_suggestions "# TODO: 🐘 Install 'gradle'. See: https://gradle.org/install/."
}
