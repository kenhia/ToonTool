# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Converts the timestamp that Blizzard uses to local time

.NOTES
    This probably needs a better fn name
#>
function ConvertFrom-UnixTimestamp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Timestamp
    )

    # hack?
    if ($Timestamp.Length -lt 13) {
        $Timestamp += '000'
    }

    $utcKind = [System.DateTimeKind]::Utc
    $unixEpoch = [datetime]::new(1970, 1, 1, 0, 0, 0, $utcKind)

    $seconds = 0
    $milliseconds = 0
    if ( -not ([Int32]::TryParse($Timestamp.Substring(0, $Timestamp.Length - 3), [ref]$seconds))) {
        return
    }
    [void] [Int32]::TryParse(($Timestamp.Substring($Timestamp.Length - 3)), [ref]$milliseconds)

    $lastPlayed = $unixEpoch + [timespan]::new(0, 0, 0, $seconds, $milliseconds)
    $lastPlayed.ToLocalTime()
}