# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Performs the login, authentication, and intial details for a user

.DESCRIPTION
    Gets the user access token and account information. Calculates when the token should expire.

    This caches the current user and will reget the token only when expiration is close. I added in a ten minute
    buffer and taking the pessimistic approach at setting the expiration for the token. Blizzard is currently
    granting token's that last one second under 24 hours, so the effect should generally be that the actual token
    is retrieved once per day-ish per session.

.NOTES
    I don't know how to "undo" user auth yet; once I've logged in on a toon on a machine, it "auto-logs".
    Suspect it's a cookie.
#>

function Get-WowUser {
    [CmdletBinding()]
    param (
        # Don't use the cache; re-login user once I figure out how to do that
        [switch]$Force
    )

    $cachedWowUser = Get-CachedVariable -Name WowUser
    if (-not $Force -and $cachedWowUser) {
        return $cachedWowUser
    }

    $now = Get-Date

    Write-Host 'Going to the web...' -ForegroundColor Magenta
    $userOauth = Get-UserOauth
    if (-not $userOauth.access_token) {
        Write-Warning 'Did not get an access token.'
        return $null
    }

    $userInfo = Get-UserInfo $userOauth.access_token

    $wowuser = [PSCustomObject]@{
        token        = $userOauth.access_token
        tokenExpires = $now.AddSeconds($userOauth.expires_in)
        tokenType    = $userOauth.token_type
        scope        = $userOauth.scope
        battletag    = $userInfo.battletag
        subscription = $userInfo.sub
        id           = $userInfo.id
    }

    Set-CachedVariable -Name WowUser -Value $wowuser -Expires $wowuser.tokenExpires -PassThru
}