# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

$WowApiMap = @{

    # -----  Character Equipment API -------------------------------------------------------------------------
    CharacterEquipmentSummary = @{
        url = '/profile/wow/character/{realmSlug}/{characterName}/equipment'
        namespace = 'profile-{Region}'
    }
    # -----  Connected Realm API  ----------------------------------------------------------------------------
    ConnectedRealmsIndex = @{
        url       = '/data/wow/connected-realm/index'
        namespace = 'dynamic-{Region}'
    }
    ConnectedRealm = @{
        url       = '/data/wow/connected-realm/{connectedRealmId}'
        namespace = 'dynamic-{Region}'
    }
    # -----  Realm API  --------------------------------------------------------------------------------------
    RealmsIndex          = @{
        url       = '/data/wow/realm/index'
        namespace = 'dynamic-{Region}'
    }
    Realm                = @{
        url       = '/data/wow/realm/{realmSlug}'
        namespace = 'dynamic-{Region}'
    }
}
$null = $WowApiMap