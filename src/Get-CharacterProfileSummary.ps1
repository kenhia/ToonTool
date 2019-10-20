# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

# https://us.api.blizzard.com/profile/wow/character/trollbane/belarsa?namespace=profile-us&locale=en_US&access_token=USblahblahblah


function Get-CharacterProfileSummary {
    [CmdletBinding()]
    param (
        $RealmSlug = 'trollbane',
        $CharacterName = 'belarsa'
    )

    $accessToken = Get-BlizzardClientToken

    $uri = "https://us.api.blizzard.com/profile/wow/character/${RealmSlug}/${CharacterName}?namespace=profile-us&locale=en_US&access_token=${accessToken}"
    $splat = @{
        Uri             = $uri
        Method          = 'GET'
        UseBasicParsing = $true
    }
    $result = Invoke-RestMethod @splat
    $result
}
