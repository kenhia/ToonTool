# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    s...

.DESCRIPTION
    d...

.NOTES
#>

function Get-WowData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Api,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us',

        [ValidateSet(('en_US', 'es_MX', 'pt_BR', 'de_DE', 'es_ES', 'fr_FR', 'it_IT', 'pt_PT', 
                'ru_RU', 'ko_KR', 'zh_TW', 'zh_CN', 'ALL'))]
        $Locale = 'en_US',

        $CacheExtension = '.json',

        # Get data from Blizzard even if we have it locally
        [switch] $Force
    )
    dynamicParam {
        Get-WowDynamicParam -Api $Api
    }

    process {
        if (-not ($WowApiMap.ContainsKey($Api))) { throw "No API '$Api' found in WowApiMap." }

        # Put in the defaults; not sure why PS doesn't
        if (-not $PSBoundParameters.ContainsKey('Region')) { $PSBoundParameters.Add('Region', 'us') }
        if (-not $PSBoundParameters.ContainsKey('Locale')) { $PSBoundParameters.Add('Locale', 'en_US') }

        $accessToken = Get-BlizzardClientToken
        ($url, $subdir) = Get-WowDataUrl @PSBoundParameters -AccessToken $accessToken -IncludeSubdir

        $cachePath = Get-GameDataCachePath -Subdir $subdir -Extension $CacheExtension
        if (-not $Force) {
            $resultContent = Get-CachedGameData -Path $cachePath
        }
        if (-not $resultContent) {
            # We are getting it from Blizzard
            try {
                $result = Invoke-WebRequest -Uri $url -Method Get
                $statusCode = $result.StatusCode
            }
            catch {
                $statusCode = $_.Exception.Response.StatusCode.value__
            }

            if ($statusCode -ne 200) {
                Write-Warning "Status Code: $StatusCode"
                return
            }

            $resultContent = $result.Content

            # Cache it
            $parent = Split-Path -Path $cachePath -Parent
            if (-not (Test-Path -Path $parent -PathType Container)) {
                mkdir $parent -ErrorAction Stop | Out-Null
            }
            Set-Content -Path $cachePath -Encoding utf8 -value $resultContent
        }

        # Emit the data!
        $resultContent | ConvertFrom-Json
    }
}
