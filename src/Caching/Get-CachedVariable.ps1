# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Attempts to retrieve a variable from the cache

.DESCRIPTION
    This function returns null if the variable is not set or has timed out.
    Variables can be placed in the cache with Set-CachedVariable.
#>

function Get-CachedVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name
    )

    if ($Module.Cache.ContainsKey($Name)) {
        $now = Get-Date
        if ($now -lt $Module.Cache[$Name].Expires) {
            $Module.Cache[$Name].Value
        }
        else {
            $Module.Cache.Remove($Name)
        }
    }
}
