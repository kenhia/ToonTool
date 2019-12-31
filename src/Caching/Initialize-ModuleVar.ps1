# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Initializes the $Module variable

.DESCRIPTION
    I dislike the $Script: variable inside a module. I think this works better :-)

.NOTES
#>

function Initialize-ModuleVar {
    $Script:Module = @{ }
}


function New-ModuleVar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        [AllowNull()]
        $Value,
        $Description = 'The author was too lazy to give this a description. Bad author, no cookie.'
    )

    if ($Module.ContainsKey($Name)) {
        throw "Internal script error; duplicate initialization of Module variable '$Name'."
    }
    $Module.Add($Name, $Value)
    $Module.Add("_d_$Name", $Description)
}

function Get-ModuleVariable {
    [CmdletBinding()]
    param()

    $keys = $Module.Keys | Where { $_ -notmatch '^_d_' } | Sort-Object
    foreach ($k in $keys) {
        # PSAnalyzer doesn't like ternary operator yet :-(
        $outval = if ($Module[$k]) { $Module[$k] } else { '--null--' }
        [PSCustomObject]@{
            Name        = $k
            # Value = $Module[$k] ? $Module[$k] : '--null--'
            Value       = $outval
            Description = $Module["_d_$k"]
        }
    }
}