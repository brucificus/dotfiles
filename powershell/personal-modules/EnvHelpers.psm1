function Measure-EnvVarChanges([ScriptBlock] $inner) {
    [Hashtable] $before = @{}
    Get-ChildItem Env:\ | %{ $orig[$_.Name] = $_.Value }

    &$inner

    [Hashtable] $after = @{}
    Get-ChildItem Env:\ | %{ $after[$_.Name] = $_.Value }

    return ($orig.Keys + $after.Keys) `
            | Select-Object -Unique `
            | %{ New-Object PSCustomObject -Property @{key = $_; before=$orig[$_]; after=$after[$_]}} `
            | ?{$_.before -ne $_.after}
}

function Test-Elevation() {
    Write-Debug "Testing elevation"
    if ($IsWindows) {
        return [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    } else {
        throw [System.NotImplementedException]::new("Test-Elevation not implemented for current platform")
    }
}

# Reads a dotenv file as a stream of name-value pairs.
function Read-DotEnv() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="FilePath", Position=0)]
        [string] $FilePath
    )
    Process {
        foreach ($line in (Get-Content -LiteralPath $FilePath)) {
            [int] $splitAt = $line.IndexOf('=')
            if ($splitAt -gt -1) {
                [string] $name = $line.Substring(0, $splitAt)
                [string] $value = $line.Substring($splitAt+1)

                [string] $valueTrimmed = $value.Trim()
                if ($valueTrimmed.StartsWith('"') -and $valueTrimmed.EndsWith('"')) {
                    $value = $valueTrimmed.Substring(1, $valueTrimmed.Length-2)
                }

                [System.Collections.DictionaryEntry] $de = [System.Collections.DictionaryEntry]::new($name, $value)
                Write-Output $de
            }
        }
    }
}

# Gets matching environment variables, requires explicit specification of scope.
# Outputs one or more objects with properties `Name` and `Value`.
function Get-EnvVar() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeAnyName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeSpecificName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeNameLike", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeAnyName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeSpecificName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeNameLike", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeAnyName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeSpecificName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeNameLike", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueAnyName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueSpecificName", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueNameLike", Position=0)]
        [System.EnvironmentVariableTarget] $Scope,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeSpecificName", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeSpecificName", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeSpecificName", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueSpecificName", Position=1)]
        [string] $Name,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeNameLike", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeNameLike", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeNameLike", Position=1)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueNameLike", Position=1)]
        [string] $NameLike
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget '$Scope'"
        }
    }
    Process {
        if ($Name) {
            [string] $value = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
            if ($null -eq $value) {
                # Intentionally left blank.
            } else {
                [System.Collections.DictionaryEntry] $de = [System.Collections.DictionaryEntry]::new($Name, $value)
                Write-Output $de
            }
        } else {
            [System.Collections.DictionaryEntry[]] $allEnvItems = Get-ChildItem Env:
            foreach ($de in $allEnvItems) {
                if ($NameLike -and ($de.Name -notlike $NameLike)) {
                    continue
                }
                if ($null -eq [System.Environment]::GetEnvironmentVariable($de.Name, $Scope)) {
                    continue
                } else {
                    Write-Output $de
                }
            }
        }
    }
}

# Sets an environment variable, requiring explicit specification of scope.
# Can accept pipeline of objects with properties `Name` and `Value`.
function Set-EnvVar() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeNAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKVP", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeDE", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeNAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKVP", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeDE", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeNAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKVP", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeDE", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueNAV", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKVP", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueDE", Position=0)]
        [System.EnvironmentVariableTarget] $Scope,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeNAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeNAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeNAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueNAV", Position=1, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeNAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeNAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeNAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueNAV", Position=2, ValueFromPipelineByPropertyName=$true)]
        [object] $Value,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeKVP", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueKVP", Position=1, ValueFromPipeline=$true)]
        [System.Collections.Generic.KeyValuePair[string, object]] $KVP,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeDE", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeDE", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeDE", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueDE", Position=1, ValueFromPipeline=$true)]
        [System.Collections.DictionaryEntry] $Entry
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget '$Scope'"
        }

        if ($IsWindows -and ($Scope -ne [System.EnvironmentVariableTarget]::Process)) {
            [bool] $isElevated = Test-Elevation
            if (-not $isElevated) {
                Write-Error "Elevated session required for updating environment variables with scope '$Scope'"
            }
        }

        if ($KVP) {
            $Name = $KVP.Key
            $Value = $KVP.Value
        }

        if ($Entry) {
            $Name = $Entry.Name
            $Value = $Entry.Value
        }
    }
    Process {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
    }
}

function Get-EnvPathItem() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValue", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValue", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValue", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValue", Position=0)]
        [System.EnvironmentVariableTarget] $Scope
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget '$Scope'"
        }
    }
    Process {
        [string] $extantPath = (Get-EnvVar -Scope $Scope -Name 'PATH').Value
        [string[]] $pathItems = $extantPath.Split([System.IO.Path]::PathSeparator, [System.StringSplitOptions]::None)

        foreach ($pathItem in $pathItems) {
            Write-Output $pathItem
        }
    }
}

function Add-EnvPathItem() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValue", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValue", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValue", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValue", Position=0)]
        [System.EnvironmentVariableTarget] $Scope,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValue", Position=1, ValueFromPipeline=$true)]
        [object] $Value,

        [Parameter(Mandatory=$false, ParameterSetName="MachineScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$false, ParameterSetName="ProcessScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$false, ParameterSetName="UserScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$false, ParameterSetName="ScopeValueForValue", Position=1, ValueFromPipeline=$true)]
        [switch] $Prepend
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget '$Scope'"
        }

        if ($IsWindows -and ($Scope -ne [System.EnvironmentVariableTarget]::Process)) {
            [bool] $isElevated = Test-Elevation
            if (-not $isElevated) {
                Write-Error "Elevated session required for EnvironmentVariableTarget '$Scope'"
            }
        }
    }
    Process {
        [string] $extantPath = (Get-EnvVar -Scope $Scope -Name 'PATH').Value
        [string[]] $pathItems = $extantPath.Split([System.IO.Path]::PathSeparator, [System.StringSplitOptions]::None)

        $pathItems = $pathItems | Where-Object { $_ -ne $Value }
        if ($Prepend -and $Prepend.IsPresent) {
            $pathItems = @(,$Value) + $pathItems
        } else {
            $pathItems = $pathItems + @(,$Value)
        }

        [string] $newPathValue = $pathItems -join [System.IO.Path]::PathSeparator
        Set-EnvVar -Scope $Scope -Name 'PATH' -Value $newPathValue
    }
}

function Remove-EnvPathItem() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValue", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValueLike", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValueMatch", Position=0)]
        [switch] $Machine,

        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValue", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValueLike", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValueMatch", Position=0)]
        [switch] $Process,

        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValue", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValueLike", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValueMatch", Position=0)]
        [switch] $User,

        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValue", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValueLike", Position=0)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValueMatch", Position=0)]
        [System.EnvironmentVariableTarget] $Scope,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValue", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValue", Position=1, ValueFromPipeline=$true)]
        [object] $Value,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValueLike", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValueLike", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValueLike", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValueLike", Position=1, ValueFromPipeline=$true)]
        [object] $ValueLike,

        [Parameter(Mandatory=$true, ParameterSetName="MachineScopeForValueMatch", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ProcessScopeForValueMatch", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="UserScopeForValueMatch", Position=1, ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true, ParameterSetName="ScopeValueForValueMatch", Position=1, ValueFromPipeline=$true)]
        [object] $ValueMatch
    )
    Begin {
        if ($Machine -and $Machine.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Machine
        } elseif ($Process -and $Process.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } elseif ($User -and $User.IsPresent) {
            $Scope = [System.EnvironmentVariableTarget]::User
        }

        if (-not [System.EnvironmentVariableTarget]::IsDefined($Scope)) {
            Write-Error "Unrecognized EnvironmentVariableTarget '$Scope'"
        }

        if ($IsWindows -and ($Scope -ne [System.EnvironmentVariableTarget]::Process)) {
            [bool] $isElevated = Test-Elevation
            if (-not $isElevated) {
                Write-Error "Elevated session required for EnvironmentVariableTarget '$Scope'"
            }
        }
    }
    Process {
        [string] $extantPath = (Get-EnvVar -Scope $Scope -Name 'PATH').Value
        [string[]] $pathItems = $extantPath.Split([System.IO.Path]::PathSeparator, [System.StringSplitOptions]::None)

        if ($Value) {
            $pathItems = $pathItems | Where-Object { $_ -ne $Value }
        } elseif ($ValueLike) {
            $pathItems = $pathItems | Where-Object { $_ -notlike $ValueLike }
        } elseif ($ValueMatch) {
            $pathItems = $pathItems | Where-Object { $_ -notmatch $ValueMatch }
        }

        [string] $newPathValue = $pathItems -join [System.IO.Path]::PathSeparator
        Set-EnvVar -Scope $Scope -Name 'PATH' -Value $newPathValue
    }
}


Export-ModuleMember -Function "Measure-EnvVarChanges"
Export-ModuleMember -Function "Test-Elevation"
Export-ModuleMember -Function "Read-DotEnv"
Export-ModuleMember -Function "Get-EnvVar"
Export-ModuleMember -Function "Set-EnvVar"
Export-ModuleMember -Function "Get-EnvPathItem"
Export-ModuleMember -Function "Add-EnvPathItem"
Export-ModuleMember -Function "Remove-EnvPathItem"
