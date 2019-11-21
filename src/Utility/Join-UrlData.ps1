# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Combines URL with URL params
#>
function Join-UrlData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Url,
        [string[]] $Params
    )
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append($Url)
    if ($Params.Count -gt 0) {
        [void]$sb.AppendFormat("?{0}", $Params[0])
        for ($i = 1; $i -lt $Params.Count; $i++) {
            [void]$sb.AppendFormat("&{0}", $Params[$i])
        }
    }
    $sb.ToString()
}
