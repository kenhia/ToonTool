# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

function Get-BlizzardData {
    [CmdletBinding()]
    param(
        $Uri = 'https://us.api.blizzard.com/data/wow/playable-race/10?namespace=static-8.2.5_31884-us'
    )

    $accessToken = Get-BlizzardClientToken
    $result = Invoke-WebRequest -Uri "${Uri}&access_token=${accessToken}" -Method Get

    $result
}