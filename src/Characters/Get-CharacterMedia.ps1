# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

function Get-CharacterMedia {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name,

        [Parameter(Mandatory)]
        $Realm,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us',

        [ValidateSet('en_US', 'es_MX', 'pt_BR', 'de_DE', 'es_ES', 'fr_FR', 'it_IT', 'pt_PT', 
                'ru_RU', 'ko_KR', 'zh_TW', 'zh_CN', 'ALL')]
        $Locale = 'en_US',

        [switch]$Avatar,
        [switch]$Render,
        [switch]$Bust,
        [switch]$All,
        [Alias('Force')]
        [switch]$Update
    )

    $splat = @{
        Api           = 'CharacterMediaSummary'
        characterName = $Name.ToLower()
        realmSlug     = Get-RealmSlug -Name $Realm
        Region        = $Region
        Locale    = $Locale
    }
    $mediaData = Get-WowData @splat

    # _links     : @{self=}
    # character  : @{key=; name=Halli; id=195910615; realm=}
    # avatar_url : https://render-us.worldofwarcraft.com/character/trollbane/215/195910615-avatar.jpg
    # bust_url   : https://render-us.worldofwarcraft.com/character/trollbane/215/195910615-inset.jpg
    # render_url : https://render-us.worldofwarcraft.com/character/trollbane/215/195910615-main.jpg
    
    function getMediaFile($url) {
        $filename = $url | Split-Path -Leaf
        $subdir = Join-Path -Path $mediaSubDir -ChildPath $filename
        $outPath = Get-GameDataCachePath -SubDir $subdir -Extension ''
        $parent = Split-Path -Path $outPath -Parent
        if (-not (Test-Path -Path $parent -PathType Container)) {
            mkdir -Path $parent | Out-Null
            if (-not (Test-Path -Path $parent -PathType Container)) {
                throw "Could not create directory: $parent."
            }
        }
        if ($Update -or (-not (Test-Path -Path $outPath -PathType Leaf))) {
            Invoke-WebRequest -Uri $url -OutFile $outPath
        }
    }

    $mediaSubDir = "media\$Region\$($splat.realmSlug)\$($splat.characterName)"
    if ($Bust -or $All) { getMediaFile($mediaData.bust_url) }
    if ($Avatar -or $All) { getMediaFile($mediaData.avatar_url) }
    if ($Render -or $All) { getMediaFile($mediaData.render_url) }
}