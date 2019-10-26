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
    I'm not validating parameters in this function as I expect it to normally be called by Get-WowData and I didn't
    want to have two places that needed to be updated if the validation sets changed.
#>

function Get-WowDataUrl {
    [CmdletBinding()]
    param (
        # API to form URL for; must be key in WowApiMap (see Get-WowApiMap)
        [Parameter(Mandatory)]
        [string] $Api,

        # Region, should be a valid WoW region (see Get-WowData)
        [Parameter(Mandatory)]
        [string] $Region,

        # Locale, should be a valid WoW locale (see Get-WowData)
        [Parameter(Mandatory)]
        [string] $Locale,

        # If not passed, caller is responsible for taking it on! (see Get-BlizzardClientToken)
        [string] $AccessToken,

        # Also emit a hint for local filesystem caching
        [switch] $IncludeSubdir,

        # Not used; included here to make call from Get-WowData easier
        [Parameter(DontShow)]
        [switch] $Force
    )
    dynamicParam {
        Get-WowDynamicParam -Api $Api
    }

    process {
        if (-not $WowApiMap.ContainsKey($Api)) { throw "API '$Api' not found in WowApiMap." }

        $start = "https://${Region}.api.blizzard.com"
        if ($Region -eq 'cn') {
            $start = 'https://gateway.battlenet.com.cn'
        }
        $namespace = $WowApiMap.$Api.namespace.Replace('{Region}', $Region)
        $urlBit = $WowApiMap.$Api.url
        $dynargs = $urlBit |
            Select-String '{(?<param>[^}]+)}' -AllMatches |
            ForEach-Object -MemberName matches |
            ForEach-Object -MemberName value
        foreach ($a in $dynargs) {
            $aPlain = $a.Substring(1, $a.Length - 2)
            if ($PSBoundParameters.ContainsKey($aPlain)) {
                $urlBit = $urlBit.Replace($a, $PSBoundParameters.$aPlain)
            }
            else {
                throw "Script error in Get-WowDataUrl; don't have needed parameter $aPlain"
            }
        }
        $localeBit = if ($Locale -eq 'ALL') { '' } else { "&locale=$locale" }
        $accessBit = if ($AccessToken) { "&access_token=$AccessToken" } else { '' }

        # Emit the URL
        "${start}${urlBit}?namespace=${namespace}${localeBit}${accessBit}"

        if ($IncludeSubdir) {
            # Emit the caching hint
            Join-Path -Path $namespace -ChildPath $locale | Join-Path -ChildPath $urlBit
        }
    }
}
