# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Retrieves game data from local cache or Blizzard

.NOTES
    All the dynamic parameter code is the same here as in Get-GameDataUrl; I thought about coding it differently but
    while my plan is to always use this function to retrieve data I can see others wanting to grab the url and do
    something else with it.

    Parameter differences between this and Get-GameDataUrl (as I'll confuse myself if I don't keep track)

                Get-GameData        Get-GameDataUrl
    AccessToken     [ ]                 [X]
    IncludeSubdir   [ ]                 [ ]
    Force           [X]                 [ ]
#>
function Get-GameData {
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
        [ValidateSet(('en_US', 'es_MX', 'pt_BR', 'de_DE', 'es_ES', 'fr_FR', 'it_IT', 'pt_PT', 
                'ru_RU', 'ko_KR', 'zh_TW', 'zh_CN', 'ALL'))]
        $Locale = 'en_US',

        # Get it from Blizzard even if we have it local
        [switch]$Force
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
        $accessToken = Get-BlizzardClientToken
        $getUrlParams = $PSBoundParameters
        if ($getUrlParams.ContainsKey('Force')) { [void]$getUrlParams.Remove('Force')}
        ($url, $subdir) = Get-GameDataUrl @getUrlParams -AccessToken $accessToken -IncludeSubDir

        $cachePath = Get-GameDataCachePath -SubDir $subdir
        if (-not $Force -and (Test-Path -Path $cachePath -PathType Leaf)) {
            Get-Content -Path $cachePath -Raw | ConvertFrom-Json
            Write-Verbose "source cache read: $cachePath"
        }
        else {
            # TODO: Add a get new token and retry here
            Write-Verbose $url
            try {
                $result = Invoke-WebRequest -Uri $url -Method Get
                $statusCode = $result.StatusCode
            }
            catch {
                $StatusCode = $_.Exception.Response.StatusCode.value__
            }

            if ($StatusCode -ne 200) {
                Write-Warning "Status Code: $StatusCode"
                return $null
            }
            # Cache it
            $parent = Split-Path -Path $cachePath -Parent
            if (-not (Test-Path -Path $parent -PathType Container)) {
                mkdir $parent -ErrorAction Stop | Out-Null
            }
            Set-Content -Path $cachePath -Encoding utf8 -Value $result.Content
            Write-Verbose "source NET cache written: $cachePath"

            # Emit it
            $result.Content | ConvertFrom-Json
        }
    }
}
