# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Gets the list of characters (name,realm,region) associated with an account [READ NOTES]

.DESCRIPTION
    Currently this is a non caching function, read the notes.

.NOTES
    This is a placeholder-ish workaround. I haven't solved getting the OAuth for the account in PowerShell yet. For
    now I'm simulating that more or less by (a) going to my test Python-Flask site that /does/ know how to do the
    OAuth, and then (b) populating a web page that I can do a cut-n-paste, and then (c) creating the 'cache' file
    that I would have created once I got the information from Blizzard.

    I'm still building out all the connecting parts, but I /think/ everything we get with /wow/user/characters
    (today) or /profile/{account-id}/wow (soon...now?) we can get with the other profile calls with the exception
    of the list of toons that belong to an account. Based on that, I /think/, we can ignore everything except for
    the Region, Name, and Realm. This does imply an ugly workaround of just creating the JSON file with a list of
    characters that you are interested in.

    Based on the previous, this function just returns an array containing the name and realm of the characters.

    TODO:
    [ ] Make this work correctly :-)
    [ ] Deal with the player's rights; if ANY of the characters are not valid, the cache file should be deleted and
        then re-got from Blizzard (which would presumably not list the user anymore)
#>

function Get-AccountCharacters {
    [CmdletBinding()]
    param (
        #[Parameter(Mandatory)]
        $AccountId = 77710311,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us',

        # Force getting from blizzard [NYI]
        [switch] $Force
    )

    $AccountId = $user.id

    # Wondering if there's an "approved" way to figure out when the last time you exited the game was
    $sentinalFile = 'C:\Program Files (x86)\World of Warcraft\_retail_\WTF\config.wtf'
    $leftAzeroth = Get-Item -Path $sentinalFile -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LastWriteTime

    $cacheDir = Join-Path -Path $Module.DataRoot -ChildPath "profile-${Region}\${AccountId}\wow"
    if (-not $cacheDir) {
        mkdir $cacheDir | Out-Null
        if (-not (Test-Path -Path $cacheDir -PathType Container)) {
            Write-Warning "Could not create cache directory for account information: $cacheDir"
            return
        }
    }
    $cacheFile = Join-Path -Path $cacheDir -ChildPath characters.json

    if (Test-Path -Path $cacheFile -PathType Leaf){
        $c = Get-Content -Path $cacheFile -Raw | ConvertFrom-Json
    }

    ## Caching all around
    ## Call with User
    ## Probably move all into Get-UserCharacters
    ## ...i.e. one stop initialization for an account

    if ((Get-Item -Path $cacheFile -ErrorAction SilentlyContinue).LastWriteTime -lt $leftAzeroth) {
        try {
            $c = Get-UserCharacters -Token
        }
        catch {
            Write-Warning "Could not get character data for account $AccountId from Blizzard"
            Write-Warning $_.Exception.Message
        }
    }


    foreach ($toon in $c.characters) {
        if ($toon.lastModified) {
            $utcTime = ConvertFrom-UnixTimestamp -Timestamp $toon.lastModified
            if ($utcTime) {
                $toon | Add-Member -NotePropertyName lastPlayedUTC -NotePropertyValue $utcTime
                $toon | Add-Member -NotePropertyName lastPlayed -NotePropertyValue $utcTime.ToLocalTime()
            }
            $toon | Add-Member -NotePropertyName 'Region' -NotePropertyValue $Region
        }
        $toon
    }
}
