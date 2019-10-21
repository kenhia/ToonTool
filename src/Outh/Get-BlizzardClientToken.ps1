# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets client token for Blizzard Developer API calls

.DESCRIPTION
    Caches result; not the expiration is not a guarentee; if a call fails using the token, a new token should be
    retrieved with the -Force switch. If this still fails then the call should be failed.

.NOTES
    Ref: https://develop.battle.net/documentation/guides/using-oauth/client-credentials-flow
    curl -u {client_id}:{client_secret} -d grant_type=client_credentials https://us.battle.net/oauth/token
#>
function Get-BlizzardClientToken {
    [CmdletBinding()]
    param (
        [switch]$Force
    )

    if (-not $Force) {
        $now = Get-Date
        if ($Script:ClientTokenCache -and ($Script:ClientTokenCache.Expires -gt $now)) {
            return $Script:ClientTokenCache.access_token
        }
    }
    ($bnetClient, $bnetSecret) = Get-ClientCredential

    # TBD: Remove the dependency on curl.exe here; should be able to do this with Invoke-WebRequest
    $u = "${bnetClient}:${bnetSecret}"
    $result = curl.exe -u $u -d grant_type=client_credentials https://us.battle.net/oauth/token 2> $null
    try { $tokenInfo = $result | ConvertFrom-Json } catch {}
    if (-not $tokenInfo.access_token) {
        throw "Could not get access token. Result: $result"
    }
    $expires = (Get-Date).AddSeconds($tokenInfo.expires_in)
    $tokenInfo | Add-Member -NotePropertyName 'Expires' -NotePropertyValue $expires

    $Script:ClientTokenCache = $tokenInfo

    return $Script:ClientTokenCache.access_token
}

