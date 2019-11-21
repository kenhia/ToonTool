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
        [switch]$Force,
        [switch]$Raw
    )

    if (-not $Force) {
        $now = Get-Date
        if ($Script:ClientTokenCache -and ($Script:ClientTokenCache.Expires -gt $now)) {
            if ($Raw) {
                $Script:ClientTokenCache
            }
            else {
                $Script:ClientTokenCache.access_token
            }
            return
        }
    }
    Write-Verbose 'Getting fresh token'
    ($bnetClient, $bnetSecret) = Get-ClientCredential

    $credPlain = '{0}:{1}' -f $bnetClient, $bnetSecret
    $utf8Encoding = [System.Text.UTF8Encoding]::new()
    $credBytes = $utf8Encoding.GetBytes($credPlain)
    $base64Auth = [Convert]::ToBase64String(($credBytes))

    $splat = @{
        Method          = 'POST'
        Uri             = 'https://us.battle.net/oauth/token'
        ContentType     = 'application/x-www-form-urlencoded'
        Body            = 'grant_type=client_credentials'
        Headers         = @{Authorization = ('Basic {0}' -f $base64auth) }
        UseBasicParsing = $true
    }
    
    try {
        $result = Invoke-WebRequest @splat
        if ($result.StatusCode -eq 200) {
            $tokenInfo = $result.Content | ConvertFrom-Json
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $status = $_.Exception.Response.StatusCode
        $errorMessage = "Could not retrieve token. Status code ($statusCode) $status"
    }

    <# ----- More or less the same thing using curl.exe ---------------------
    $u = "${bnetClient}:${bnetSecret}"
    $result = curl.exe -u $u -d grant_type=client_credentials https://us.battle.net/oauth/token 2> $null
    try { $tokenInfo = $result | ConvertFrom-Json } catch {}
    if (-not $tokenInfo.access_token) {
        throw "Could not get access token. Result: $result"
    }
    ---------------------------------------------------------------------- #>
    if ($tokenInfo) {
        $expires = (Get-Date).AddSeconds($tokenInfo.expires_in)
        $tokenInfo | Add-Member -NotePropertyName 'Expires' -NotePropertyValue $expires
    
        $Script:ClientTokenCache = $tokenInfo

        if ($Raw) {
            $Script:ClientTokenCache
        }
        else {
            $Script:ClientTokenCache.access_token
        }
    }
    else {
        throw $errorMessage
    }
}

