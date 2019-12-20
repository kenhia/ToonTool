# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Tests if a character is still valid.

.DESCRIPTION
    Per Blizzard:

    Returns the status and a unique ID for a character. A client should delete information about a character from their application if any of the following conditions occur:

    * an HTTP 404 Not Found error is returned
    * the is_valid value is false
    * the returned character ID doesn't match the previously recorded value for the character

    Within this module, all cached character information is stored [ADD NOTES HERE]

.NOTES
#>

function Test-CharacterValid {
    [CmdletBinding(DefaultParameterSetName = 'param')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'pipe')]
        $InputObject,

        [Parameter(Mandatory, ParameterSetName = 'param')]
        $Realm,

        [Parameter(Mandatory, ParameterSetName = 'param')]
        $Name,

        [Parameter(ParameterSetName = 'param')]
        $Region = 'us'
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'param') {
            $InputObject = [PSCustomObject]@{
                realm  = $Realm
                name   = $Name
                region = $Region
            }
        }
    }

    process {
        foreach ($item in $InputObject) {
            $splat = @{
                Api           = 'CharacterProfileStatus'
                realmSlug     = Get-RealmSlug -Name $item.realm
                characterName = $item.name.ToLower()
                Region        = $item.region.ToLower()
                # Always need to get this new
                Force         = $true
            }
            try {
                $result = Get-WowData @splat
                $isValid = ($null -ne $result.is_valid) -and $result.is_valid
            }
            catch {
                $_
                $isValid = $false
            }
            if ('is_valid' -in ($item | Get-Member -MemberType NoteProperty).Name) {
                $item.is_valid = $isValid
            }
            else {
                $item | Add-Member -NotePropertyName 'is_valid' -NotePropertyValue $isValid
            }
            $item
        }
    }
}

<#
https://us.api.blizzard.com/profile/wow/character/trollbane/belarsa/status?namespace=profile-us&locale=en_US&access_token=UStqbLXpzQ3u8ANjt3KylIu5hgFKj7fN24
https://us.api.blizzard.com/profile/wow/character/trollbane/belarsa/status?namespace=static-us&local=en_US&access_token=USSP696K27BEKIeJGfaTyW9GidP6S9Zg1e


#>