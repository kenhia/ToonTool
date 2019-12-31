# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

function Get-WowUserCharacters {
    [CmdletBinding()]
    param(
        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    # Get-WowUser does caching so okay to call it frequently
    $wowuser = Get-WowUser
    $token = $wowuser.Token
    if (-not $token) {
        throw 'Could not get token for user.'
    }
    if ($Region -eq 'cn') {
        $urlbase = 'https://gateway.battlenet.com.cn'
    }
    else {
        $urlbase = "https://${Region}.api.blizzard.com"
    }
    $url = "$urlbase/wow/user/characters"

    $authorization = @{ Authorization = "Bearer $token" }
    $tmp = Invoke-RestMethod -Method Get -Uri $url -Headers $authorization
    $characters = $tmp.characters
    if (-not $characters) {
        throw "Could not get toon list."
    }
    foreach ($c in $characters) {
        $gender = $c.gender
        # Get the race; if not cached, it will be after first call to specific index
        $raceInfo = Get-WowData -Api PlayableRace -playableRaceId $c.race
        $raceName = Get-GenderName -Object $raceInfo -Gender $gender -Id $c.race
        $c | Add-Member -NotePropertyName raceName -NotePropertyValue $raceName
        $c | Add-Member -NotePropertyName raceExtended -NotePropertyValue $raceInfo

        # Get the class; ditto
        $classInfo = Get-WowData -Api PlayableClass -classId $c.class
        $className = Get-GenderName -Object $classInfo -Gender $gender -id $c.class
        $c | Add-Member -NotePropertyName className -NotePropertyValue $className
        $c | Add-Member -NotePropertyName classExtended -NotePropertyValue $classInfo
    }

    $characters
}

function Get-WowUserCharactersNew {
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