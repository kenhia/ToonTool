# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    s...

.DESCRIPTION
    d...

.NOTES
#>

function Set-CachedVariable {
    [CmdletBinding(DefaultParameterSetName='timeout')]
    param (
        [Parameter(Mandatory,ParameterSetName='timeout')]
        [Parameter(Mandatory,ParameterSetName='expires')]
        $Name,

        [Parameter(Mandatory,ParameterSetName='timeout')]
        [Parameter(Mandatory,ParameterSetName='expires')]
        $Value,

        [Parameter(ParameterSetName='timeout')]
        $Timeout = 60,

        [Parameter(Mandatory,ParameterSetName='expires')]
        [DateTime]$Expires
    )

    if ($PSCmdlet.ParameterSetName -eq 'timeout') {
        if ($Timeout -is [timespan]) {
            $Expires = (Get-Date) + $Timeout
        }
        else {
            $Expires = (Get-Date).AddMinutes($Timeout)
        }
    }

    $Module._Cache[$Name] = [PSCustomObject]@{
        PSTypeName = 'ModuleCachedVariable'
        Value = $Value
        Expires = $Expires
    }
}

function Get-CachedVar {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name
    )

    if ($Module._Cache.ContainsKey($Name)) {
        $now = Get-Date
        if ($now -lt $Module._Cache.Expires) {
            $Module._Cache[$Name].Value
        }
        else {
            $Module._Cache.Remove($Name)
        }
    }
}

function Initialize-ModuleVar {
    $Script:Module = @{
        _Cache = @{}
    }
}