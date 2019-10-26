# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets the Realms for a Region

.NOTES
    TODO: Add in the connected Realms in some fashion
#>

function Get-Realms {
    [CmdletBinding()]
    param (
        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    # TODO: This should be a force to allow detecting new realms (or deleted ones); not making it force
    #       for now as I don't want to keep smacking Blizzard while I test
    $index = Get-WowData -Api RealmsIndex -Region $Region
    $activity = 'Getting Realm Data'
    Write-Progress -Activity $activity -PercentComplete 0
    $realmCount = $index.realms.Count
    $counter = 0
    foreach ($slug in $index.realms.slug) {
        $counter++
        Write-Progress -Activity $activity -Status $slug -PercentComplete (100 * ($counter/$realmCount))

        # Emit the realm
        Get-WowData -Api Realm -realmSlug $slug -Region $Region
    }
    Write-Progress -Activity $activity -Completed
}