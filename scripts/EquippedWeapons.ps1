# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets the iLvl and Weapon Level for max level toons
#>

[CmdletBinding()]
param (
    # Account to retrieve
    $AccountId = 77710311,

    # Include the little guys
    [switch]$IncludeNonMax
)

function Get-ILevel {
    param(
        [Parameter(Mandatory)]
        $EquippedItems,
        [switch]$Exact
    )

    $levelItems = $EquippedItems | where { $_.slot.name -notin ('Shirt', 'Tabard') }

    $sumOfItems = $levelItems |
        where { $_.slot.name -notin ('Shirt', 'Tabard') } |
        ForEach-Object { $_.level.value } |
        Measure-Object -Sum |
        Select -ExpandProperty Sum

    # Don't think this completely correct, but it should work for now (if you are allowed to have an off hand but
    # don't does WoW divide by 16?)
    $divisor = if ($levelItems | where { $_.slot.name -eq 'Off Hand'}) { 16 } else { 15 }

    $iLvlRaw = $sumOfItems / $divisor
    if ($Exact) {
        $iLvlRaw
    }
    else {
        # Round to 2 decimals
        [math]::Round($iLvlRaw,2)
    }
}

$maxLevel = Get-CharacterMaxLevel
$toonList = Get-AccountCharacters -AccountId $AccountId
# TEMP
#$toonList = $toonList | where name -in ('belarsa', 'monkra')
if (-not $IncludeNonMax) {
    $toonList = $toonList | where level -EQ $maxLevel
}

if ($toonList.Count -eq 0) {
    Write-Warning "No toons found for AccountId $AccountId."
    return
}

foreach ($toon in $toonList) {
    $slug = Get-RealmSlug -Name $toon.realm
    $equipRaw = Get-WowData -Api CharacterEquipmentSummary -realmSlug $slug -characterName $toon.name.ToLower()
    if (-not $equipRaw) {
        Write-Warning "Could not retrieve equipment for $($toon.name)"
    }
    $equip = $equipRaw.equipped_items
    $iLevel = Get-ILevel -EquippedItems $equip

    $main = $equip | where { $_.slot.name -eq 'Main Hand' }
    $offhand = $equip | where { $_.slot.name -eq 'Off Hand' }
    $obj = [PSCustomObject] @{
        name = $toon.name
        realm = $toon.realm
        spec = $toon.spec.name
        class = Get-ClassName -ClassId $toon.class
        iLvl = $iLevel
        MainLvl = if ($main) { $main.level.value } else { 0 }
        OffHandLvl = '---'
    }
    if ($offhand) {
        $obj.OffHandLvl = $offhand.level.value
    }
    $obj
}

