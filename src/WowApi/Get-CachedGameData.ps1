# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets data from local file cache if available; otherwise null

.NOTES
    Do I want a general timeout for data? I added one then commented it out.
#>

function Get-CachedGameData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Path
    )

    if (Test-Path -Path $Path -PathType Leaf) {
        # $timeout = (Get-Date).AddDays(-30)
        # $fileItem = Get-Item -Path $Path
        # if ($fileItem.LastWriteTime -lt $timeout) { return }
        Get-Content -Path $Path -Raw
    }
}