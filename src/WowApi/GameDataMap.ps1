# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

$GameDataMap = @{
    # Achievement API
    AchievementCategoriesIndex      = '/data/wow/achievement-category/index'
    AchievementCategory             = '/data/wow/achievement-category/{achievementCategoryId}'
    AchievementsIndex               = '/data/wow/achievement/index'
    Achievement                     = '/data/wow/achievement/{achievementId}'
    AchievementMedia                = '/data/wow/media/achievement/{achievementId}'

    # Azerite Essence API
    AzeriteEssencesIndex            = '/data/wow/azerite-essence/index'
    AzeriteEssence                  = '/data/wow/azerite-essence/{azeriteEssenceId}'
    AzeriteEssenceMedia             = '/data/wow/media/azerite-essence/{azeriteEssenceId}'

    # Connected Realm API
    ConnectedRealmsIndex            = '/data/wow/connected-realm/index'
    ConnectedRealm                  = '/data/wow/connected-realm/{connectedRealmId}'

    # Creature API
    CreatureFamiliesIndex           = '/data/wow/creature-family/index'
    CreatureFamily                  = '/data/wow/creature-family/{creatureFamilyId}'
    CreatureTypesIndex              = '/data/wow/creature-type/index'
    CreatureType                    = '/data/wow/creature-type/{creatureTypeId}'
    Creature                        = '/data/wow/creature/{creatureId}'
    CreatureDisplayMedia            = '/data/wow/media/creature-display/{creatureDisplayId}'
    CreatureFamilyMedia             = '/data/wow/media/creature-family/{creatureFamilyId}'

    # Guild Crest API
    GuildCrestComponentsIndex       = '/data/wow/guild-crest/index'
    GuildCrestBorderMedia           = '/data/wow/media/guild-crest/border/{borderId}'
    GuildCrestEmblemMedia           = '/data/wow/media/guild-crest/emblem/{emblemId}'

    # Item API
    ItemClassesIndex                = '/data/wow/item-class/index'
    ItemClass                       = '/data/wow/item-class/{itemClassId}'
    ItemSubclass                    = '/data/wow/item-class/{itemClassId}/item-subclass/{itemSubclassId}'
    Item                            = '/data/wow/item/{itemId}'
    ItemMedia                       = '/data/wow/media/item/{itemId}'

    # Mythic Keystone Affix API
    MythicKeystoneAffixesIndex      = '/data/wow/keystone-affix/index'
    MythicKeystoneAffix             = '/data/wow/keystone-affix/{keystoneAffixId}'

    # Mythic Raid Leaderboard API
    MythicRaidLeaderboard           = '/data/wow/leaderboard/hall-of-fame/{raid}/{faction}'

    # Mount API
    MountsIndex                     = '/data/wow/mount/index'
    Mount                           = '/data/wow/mount/{mountId}'

    # Mythic Keystone Dungeon API
    MythicKeystoneDungeonsIndex     = '/data/wow/mythic-keystone/dungeon/index'
    MythicKeystoneDungeon           = '/data/wow/mythic-keystone/dungeon/{dungeonId}'
    MythicKeystoneIndex             = '/data/wow/mythic-keystone/index'
    MythicKeystonePeriodsIndex      = '/data/wow/mythic-keystone/period/index'
    MythicKeystonePeriod            = '/data/wow/mythic-keystone/period/{periodId}'
    MythicKeystoneSeasonsIndex      = '/data/wow/mythic-keystone/season/index'
    MythicKeystoneSeason            = '/data/wow/mythic-keystone/season/{seasonId}'

    # Mythic Keystone Leaderboard API
    MythicKeystoneLeaderboardsIndex = '/data/wow/connected-realm/{connectedRealmId}/mythic-leaderboard/index'
    MythicKeystoneLeaderboard       = '/data/wow/connected-realm/{connectedRealmId}/mythic-leaderboard/{dungeonId}/period/{period}'

    # Pet API
    PetsIndex                       = '/data/wow/pet/index'
    Pet                             = '/data/wow/pet/{petId}'

    # Playable Class API
    PlayableClassesIndex            = '/data/wow/playable-class/index'
    PlayableClass                   = '/data/wow/playable-class/{classId}'
    PlayableClassMedia              = '/data/wow/media/playable-class/{playableClassId}'
    PvPTalentSlots                  = '/data/wow/playable-class/{classId}/pvp-talent-slots'

    # Playable Race API
    PlayableRacesIndex              = '/data/wow/playable-race/index'
    PlayableRace                    = '/data/wow/playable-race/{playableRaceId}'

    # Playable Specialization API
    PlayableSpecializationsIndex    = '/data/wow/playable-specialization/index'
    PlayableSpecialization          = '/data/wow/playable-specialization/{specId}'

    # Power Type API
    PowerTypesIndex                 = '/data/wow/power-type/index'
    PowerType                       = '/data/wow/power-type/{powerTypeId}'

    # PvP Season API
    PvPSeasonsIndex                 = '/data/wow/pvp-season/index'
    PvPSeason                       = '/data/wow/pvp-season/{pvpSeasonId}'
    PvPLeaderboardsIndex            = '/data/wow/pvp-season/{pvpSeasonId}/pvp-leaderboard/index'
    PvPLeaderboard                  = '/data/wow/pvp-season/{pvpSeasonId}/pvp-leaderboard/{pvpBracket}'
    PvPRewardsIndex                 = '/data/wow/pvp-season/{pvpSeasonId}/pvp-reward/index'

    # PvP Tier API
    PvPTierMedia                    = '/data/wow/media/pvp-tier/{pvpTierId}'
    PvPTiersIndex                   = '/data/wow/pvp-tier/index'
    PvPTier                         = '/data/wow/pvp-tier/{pvpTierId}'

    # Realm API
    RealmsIndex                     = '/data/wow/realm/index'
    Realm                           = '/data/wow/realm/{realmSlug}'

    # Region API
    RegionsIndex                    = '/data/wow/region/index'
    Region                          = '/data/wow/region/{regionId}'

    # Reputations API
    ReputationFactionsIndex         = '/data/wow/reputation-faction/index'
    ReputationFaction               = '/data/wow/reputation-faction/{reputationFactionId}'
    ReputationTiersIndex            = '/data/wow/reputation-tiers/index'
    ReputationTiers                 = '/data/wow/reputation-tiers/{reputationTiersId}'

    # Title API
    TitlesIndex                     = '/data/wow/title/index'
    Title                           = '/data/wow/title/{titleId}'

    # WoW Token API
    WoWTokenIndex                   = '/data/wow/token/index'

}
# I dislike nagging squigglies
$null = $GameDataMap
