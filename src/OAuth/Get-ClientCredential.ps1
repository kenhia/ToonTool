# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets client id and secret from environment vars

.DESCRIPTION
    Wrapping this here so that it can be extended for other ways to get the ID and secret later.
    Also so there isn't the duplication of the not found exception
#>
function Get-ClientCredential {
    [CmdletBinding()]
    param (
    )

    $bnetClient = $env:BLIZ_CLIENT_ID
    $bnetSecret = $env:BLIZ_API_SECRET
    if (-not $bnetClient -or -not $bnetSecret) {
        throw 'One or both of the environment vars BLIZ_CLIENT_ID and/or BLIZ_API_SECRET not set; cannot continue'
    }

    $bnetClient
    $bnetSecret
}

