# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    s...

.DESCRIPTION
    d...

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
        $Region = 'us'
    )

    $cacheDir = Join-Path -Path $Module.DataRoot -ChildPath "profile-${Region}\${AccountId}\wow"
    if (-not (Test-Path -Path $cacheDir -PathType Container)) {
        Write-Warning "Directory not found: $cacheDir"
        return
    }
    $cacheFile = Join-Path -Path $cacheDir -ChildPath characters.json
    if (-not (Test-Path -Path $cacheFile -PathType Leaf)) {
        Write-Warning "File not found: $cacheFile"
        return
    }
    $c = Get-Content -Path $cacheFile -Raw | ConvertFrom-Json

    # Emit the list
    $c.characters | Select-Object name,realm
}