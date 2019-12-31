# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

$WowApiMap = @{

    # -----  Character Equipment  ----------------------------------------------------------------------------
    CharacterEquipmentSummary = @{
        url       = '/profile/wow/character/{realmSlug}/{characterName}/equipment'
        namespace = 'profile-{Region}'
    }
    CharacterMediaSummary     = @{
        url       = '/profile/wow/character/{realmSlug}/{characterName}/character-media'
        namespace = 'profile-{Region}'
    }
    # ----- Character Profile --------------------------------------------------------------------------------
    CharacterProfileSummary   = @{
        url       = '/profile/wow/character/{realmSlug}/{characterName}'
        namespace = 'profile-{Region}'
    }
    CharacterProfileStatus    = @{
        url       = '/profile/wow/character/{realmSlug}/{characterName}/status'
        namespace = 'profile-{Region}'
    }
    # -----  Connected Realm   -------------------------------------------------------------------------------
    ConnectedRealmsIndex      = @{
        url       = '/data/wow/connected-realm/index'
        namespace = 'dynamic-{Region}'
    }
    ConnectedRealm            = @{
        url       = '/data/wow/connected-realm/{connectedRealmId}'
        namespace = 'dynamic-{Region}'
    }
    # -----  Item -------------------------------------------------------------------------------------------
    ItemClassesIndex          = @{
        url       = '/data/wow/item-class/index'
        namespace = 'static-{Region}'
    }
    ItemClass = @{
        url = '/data/wow/item-class/{itemClassId}'
        namespace = 'static-{Region}'
    }
    ItemSubclass = @{
        url = '/data/wow/item-class/{itemClassId}/item-subclass/{itemSubclassId}'
        namespace = 'static-{Region}'
    }
    Item = @{
        url = '/data/wow/item/{itemId}'
        namespace = 'static-{Region}'
    }
    ItemMedia = @{
        url = '/data/wow/media/item/{itemId}'
        namespace = 'static-{Region}'
    }
    # ------ Playable Class ----------------------------------------------------------------------------------
    PlayableClassesIndex      = @{
        url       = '/data/wow/playable-class/index'
        namespace = 'static-{Region}'
    }
    PlayableClass             = @{
        url       = '/data/wow/playable-class/{classId}'
        namespace = 'static-{Region}'
    }
    PlayableClassMedia        = @{
        url       = '/data/wow/media/playable-class/{classId}' # {playableClassId}
        namespace = 'static-{Region}'
    }
    PvpTalentSlots            = @{
        url       = '/data/wow/playable-class/{classId}/pvp-talent-slots'
        namespace = 'static-{Region}'
    }
    # -----  Playable Race -----------------------------------------------------------------------------------
    PlayableRacesIndex        = @{
        url       = '/data/wow/playable-race/index'
        namespace = 'static-{Region}'
    }
    PlayableRace              = @{
        url       = '/data/wow/playable-race/{playableRaceId}'
        namespace = 'static-{Region}'
    }
    # -----  Realm   -----------------------------------------------------------------------------------------
    RealmsIndex               = @{
        url       = '/data/wow/realm/index'
        namespace = 'dynamic-{Region}'
    }
    Realm                     = @{
        url       = '/data/wow/realm/{realmSlug}'
        namespace = 'dynamic-{Region}'
    }
}
$null = $WowApiMap