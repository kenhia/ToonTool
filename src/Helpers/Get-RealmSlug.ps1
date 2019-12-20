# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Maps a realm name (or id) to the realmSlug
#>
function Get-RealmSlug {
    [CmdletBinding(DefaultParameterSetName = 'name')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'name', Position = 0)]
        $Name,
        [Parameter(Mandatory, ParameterSetName = 'id')]
        $Id
    )

    $realmsIndex = Get-WowData -Api RealmsIndex | Select-Object -ExpandProperty realms
    if (-not $realmsIndex) {
        Write-Warning 'Could not retrieve Realms Index.'
        return
    }
    
    switch ($PSCmdlet.ParameterSetName) {
        'name' { $slug = $realmsIndex | where name -eq $Name | select -ExpandProperty slug }
        'id' { $slug = $realmsIndex | where id -eq $Id | select -ExpandProperty slug }
        default { throw 'Internal script error in Get-RealmSlug' }
    }

    if (-not $slug) {
        Write-Warning "Realms index did not have a value matching $($PSCmdlet.ParameterSetName):${Name}${Id}"
    }

    $slug
}