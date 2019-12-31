# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Sets a variable into the in-memory cache for later retrieval

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
        [DateTime]$Expires,

        # Set the cached variable to stay valid for the entire session. Note that a session could be longed lived.
        # Note: this switch will override a timeout passed as a parameter.
        [switch]$NoExpire,

        # Emit the value
        [switch]$PassThru
    )

    if ($PSCmdlet.ParameterSetName -eq 'timeout') {
        if ($Timeout -is [timespan]) {
            $Expires = (Get-Date) + $Timeout
        }
        else {
            $Expires = (Get-Date).AddMinutes($Timeout)
        }
    }
    if ($NoExpire) {
        $Expires = [DateTime]::MaxValue
    }

    $Script:Module.Cache[$Name] = [PSCustomObject]@{
        PSTypeName = 'ModuleCachedVariable'
        Value = $Value
        Expires = $Expires
    }

    if ($PassThru) {
        $Value
    }
}
