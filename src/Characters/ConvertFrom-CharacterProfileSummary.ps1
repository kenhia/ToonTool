# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Converts the CharacterProfileSummary into something a bit more manageable for PS

.NOTES
    This throws away a lot of information returned from the API call and is not 100% a match for the toon data
    that you get from Get-AccountCharacters. If you need the data from one of those, use one of those :-)

    For my uses, the data from CharacterProfileSummary has already done a lot of the converting id's to names so
    I can take advantage of that and piece together something that will be nice for select statements.
#>

function ConvertFrom-CharacterProfileSummary {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $ProfileSummary,
        [switch]$Strict
    )
    begin {
        $expected = @('achievements', 'achievement_points', 'active_spec', 'active_title', 'appearance',
            'average_item_level', 'character_class', 'collections', 'equipment', 'equipped_item_level',
            'experience', 'faction', 'gender', 'id', 'last_login_timestamp', 'level', 'media',
            'mythic_keystone_profile', 'name', 'pvp_summary', 'race', 'raid_progression', 'realm', 'reputations',
            'specializations', 'statistics', 'titles', '_links')
        $optional = @('guild')
        $null = $optional
    }
    process {
        foreach ($summary in $ProfileSummary) {
            if ($Strict) {
                $members = $summary | Get-Member -MemberType NoteProperty | select -ExpandProperty Name
                foreach ($item in $expected) {
                    if ($item -notin $members) {
                        Write-Warning "Did not find expected member, '$item', in ProfileSummary"
                    }
                }
            }

            $name = $summary.name
            if ($summary.active_title) {
                $titleDisplay = $summary.active_title.display_string.Replace('{name}', $name)
            }
            if ($summary.guild) {
                $guildString = '{0} ({1})' -f $summary.guild.name, $summary.guild.realm.name
            }
            else {
                $guildString = '-No Guild-'
            }
            if ($summary.last_login_timestamp) {
                $utcTime = ConvertFrom-UnixTimestamp -Timestamp $summary.last_login_timestamp
                $localTime = $utcTime.ToLocalTime()
            }

            [PSCustomObject]@{
                id                = $summary.id
                name              = $summary.name
                gender            = $summary.gender.name
                faction           = $summary.faction.name
                race              = $summary.race.name
                class             = $summary.character_class.name
                spec              = $summary.active_spec.name
                realm             = $summary.realm.name
                realmSlug         = $summary.realm.slug
                guild             = $guildString
                level             = $summary.level
                experience        = $summary.experience
                achievementPoints = $summary.achievement_points
                lastModified      = $summary.last_login_timestamp
                lastPlayedUTC     = $utcTime
                lastPlayed        = $localTime
                iLvl              = $summary.average_item_level
                equipped          = $summary.equipped_item_level
                activeTitle       = $summary.active_title.name
                displayTitle      = $titleDisplay
            }
        }
    }
}