# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets the Connected Realms for a Region

.NOTES
    Need to think about how to tie this together; thinking I use the URL in a hash as each Realm has that.
#>

function Get-ConnectedRealms {
    [CmdletBinding()]
    param (
        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    $index = Get-WowData -Api ConnectedRealmsIndex
    $activity = 'Getting Connected Realm Data'
    Write-Progress -Activity $activity -PercentComplete 0
    $count = $index.connected_realms.href.Count
    $counter = 0
    $FirstWarning = $true
    foreach ($url in $index.connected_realms.href) {
        $counter++
        if ($url -match '/(?<crId>[0-9]+)\?namespace') {
            $crId = $Matches.crId
            $wpSplat = @{
                Activity        = $activity
                Status          = "Connected Realm $crId"
                PercentComplete = (100 * ($counter / $count))
            }
            Write-Progress @wpSplat
            Get-WowData -Api ConnectedRealm -connectedRealmId $crId -Region $Region
        }
        else {
            if ($FirstWarning) {
                Write-Warning "URL did not match pattern: $url"
                $FirstWarning = $true
            }
        }
    }

}