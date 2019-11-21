# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets a random string to use for state
.NOTES
    This doesn't strike me as particularly efficient, but I don't need to use this much and even on a slow machine
    it only takes about 10ms (about 2-5 on a decent machine which is in the noise for measure-command).

    And yes, I was amusing myself when naming this function
#>
function Get-StateSecret {
    $c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz'
    $sb = [System.Text.StringBuilder]::new(44)
    for ($i = 0; $i -lt 40; $i++) {
        [void]$sb.Append($c[(Get-Random -Maximum $c.Length)])
    }
    $sb.ToString()
}

