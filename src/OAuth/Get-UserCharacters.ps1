# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

function Get-UserCharacters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Token,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    if ($Region -eq 'cn') {
        $urlbase = 'https://gateway.battlenet.com.cn'
    }
    else {
        $urlbase = "https://${Region}.api.blizzard.com"
    }
    $url = "$urlbase/wow/user/characters"

    $authorization = @{ Authorization = "Bearer $Token" }
    Invoke-RestMethod -Method Get -Uri $url -Headers $authorization
}

function Get-UserCharactersNew {
    # THIS DOES NOT APPEAR TO BE WORKING YET...no idea if I'm doing it right
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Token,

        # [Parameter(Mandatory)]
        $AccountId = '77710311',

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    if ($Region -eq 'cn') {
        $urlbase = 'https://gateway.battlenet.com.cn'
    }
    else {
        $urlbase = "https://${Region}.api.blizzard.com"
    }
    $url = "$urlbase/profile/${AccountId}/wow"

    $authorization = @{ Authorization = "Bearer $Token" }
    Invoke-RestMethod -Method Get -Uri $url -Headers $authorization
}