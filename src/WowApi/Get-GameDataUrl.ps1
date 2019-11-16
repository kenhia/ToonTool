# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Composes a WoW Game Data URL based on the map in GameDataMap.

.DESCRIPTION
    The hashtable GameDataMap has entries that contain the API part of the Game Data APIs; these include
    required parameters like {itemClassId} and {itemSubclassId} in the example below:

        ItemSubclass = '/data/wow/item-class/{itemClassId}/item-subclass/{itemSubclassId}'

    This function dynamically adds these items as required parameters when calling the function with the
    given ApiName.

    If the switch $IncludeSubdir is set, this function will return two values, the first will be the normal
    URL, the second will be a value suitable for use as a subdir when caching static/seldom changing values.
    In use for items such as playable races or other data not expected to change much, you can call this function
    with the -IncludeSubdir and use the caching hit to compose a filepath with something like:

    Note: IF THIS MESSAGE IS STILL HERE...then I haven't tested the below after getting all the pieces working.

    ($url, $cacheSub) = Get-GameDataUrl -ApiName Achievement -AchievementId 13470 -IncludeSubdir
    $cachePath = Join-Path -Path $cacheRoot -ChildPath $cacheSub
    if (Test-Path -Path $cachePath -PathType Leaf) {
        $result = Get-Content -Raw -Path $cachePath | ConvertFrom-Json
    }
    else {
        $result = Get-BlizzardData -CacheTo $cachePath
    }

.NOTES
    [[ Locale ]]
    Locale can be set to one of the Blizzard supported locales or to 'ALL'. When set to 'ALL' the locale
    portion of the API URL is omitted and key values will be returned as an array of items with keys of the
    locale and localized values.

    See https://develop.battle.net/documentation/guides/game-data-apis-wow-localization for information.

    NB: I haven't tested this a lot, so I don't know if it works for all APIs.

    [[ Namespace ]]
    If you do not use 'AUTO' for the namespace, you must provide a valid namespace, e.g. 'static-us'

    [[ TODO ]]
    * Make this platform agnostic, current the IncludeSubdir returns a Windows formatted path (backslashes).

.EXAMPLE
    $url = Get-GameDataUrl -ApiName Achievement -AchievementId 13470

    Generate the URL for the achievement details for the achievement 'Rest in Pistons' with
        Region: us
        Namespace: static-us
        Locale: en_US

.EXAMPLE
    ($url, $cacheSub) = Get-GameDataUrl -ApiName Achievement -AchievementId 13470 -IncludeSubdir

    Same as above but returns the tuple of the url and the subdirectory hint for caching.
#>
function Get-GameDataUrl {
    [CmdletBinding()]
    param(
        # API Name (see GameDataMap.ps1)
        [Parameter(Mandatory)]
        $ApiName,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us',

        # Unless auto, this is put in for namespace; if you leave it at auto it will be 'static-{Region}'
        $Namespace = 'AUTO',

        # Use ALL to omit the locale and get all localized key values
        [ValidateSet('en_US', 'es_MX', 'pt_BR', 'de_DE', 'es_ES', 'fr_FR', 'it_IT', 'pt_PT', 
                'ru_RU', 'ko_KR', 'zh_TW', 'zh_CN', 'ALL')]
        $Locale = 'en_US',

        # Access token is needed, but I can see cases where you'd want to tack it on later/update/etc.
        $AccessToken,

        [switch]$IncludeSubdir
    )
    dynamicParam {
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

        # Args needed for the API that we are using
        if ($GameDataMap.ContainsKey($ApiName + '')) {
            $urlBit = $GameDataMap[$ApiName]
            $args = $urlBit |
                Select-String '{(?<param>[^}]+)}' -AllMatches |
                ForEach-Object -MemberName matches |
                ForEach-Object -MemberName value
            $pos = 0
            if ($args.Count -gt 0) {
                foreach ($a in $args) {
                    # strip the curlies
                    $aName = $a.Substring(1, $a.Length - 2)

                    $pos++

                    $argAttr = [System.Management.Automation.ParameterAttribute]::new()
                    $argAttr.Mandatory = $true
                    $argAttr.Position = $pos
                    $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                    $attributeCollection.Add($argAttr)
                    $argParam = [System.Management.Automation.RuntimeDefinedParameter]::new($aName, [string], $attributeCollection)
                    $paramDictionary.Add($aName, $argParam)
                }
            }
        }
        return $paramDictionary
    }

    end {
        if (-not $GameDataMap.ContainsKey($ApiName)) {
            throw "No API named $ApiName found"
        }
        $start = "https://${Region}.api.blizzard.com"
        if ($Region -eq 'cn') {
            $start = 'https://gateway.battlenet.com.cn'
        }
        $urlBit = $GameDataMap[$ApiName]
        $dynargs = $urlBit |
            Select-String '{(?<param>[^}]+)}' -AllMatches |
            ForEach-Object -MemberName matches |
            ForEach-Object -MemberName value

        foreach ($a in $dynargs) {
            $aName = $a.Substring(1, $a.Length - 2)
            if ($PSBoundParameters.ContainsKey($aName)) {
                $urlBit = $urlBit.Replace($a, $PSBoundParameters.$aName)
            }
            else {
                throw "Script error in Get-GameDataUrl; don't have needed parameter $aName"
            }
        }
        $namespaceBit = if ($Namespace -ne 'AUTO') { "?namespace=$Namespace" } else { "?namespace=static-${Region}" }
        $localeBit = if ($Locale -eq 'ALL') { '' } else { "&local=$Locale" }
        $accessBit = if ($AccessToken) { "&access_token=$AccessToken" } else { '' }

        # Emit the URL
        "${start}${urlBit}${namespaceBit}${localeBit}${accessBit}"

        if ($IncludeSubdir) {
            $pathNamespaceBit = if ($Namespace -ne 'AUTO') { "$Namespace" } else { "static-${Region}" }
            $pathLocaleBit = $Locale
            $urlMapped = $urlBit.Replace('/','\')

            # Emit the caching hint
            "${pathNamespaceBit}\${pathLocaleBit}${urlMapped}"
        }
    }
}
