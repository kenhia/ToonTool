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
        [int64]$Timestamp
    )
    $unixEpoch = [datetime]::new(1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)

    $seconds = 0
    $milliseconds = 0
    $timestring = $Timestamp.ToString()
    if ( -not ([Int32]::TryParse($timestring.Substring(0, $timestring.Length - 3), [ref]$seconds))) {
        return
    }
    [void] [Int32]::TryParse(($timestring.Substring($timestring.Length - 3)), [ref]$milliseconds)

    $utcKind = [System.DateTimeKind]::Utc

    $lastPlayed = $unixEpoch + [timespan]::new(0, 0, 0, $seconds, $milliseconds)
    $lastPlayed
}