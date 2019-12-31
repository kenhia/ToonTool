# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Attempts to retrieve the gender specific name for a race, class, etc

.DESCRIPTION
    Putting this in to simplify code that gets the name from ID's and to make it simpler to add in localization
    if needed after I test what the keys are when locale is *not* en-US.

.NOTES
    Allowing null and mapping it to 'Unknown[id]' so we don't have to throw if we didn't get the information for
    some reason.
#>
function Get-GenderName {
    [CmdletBinding()]
    param(
        [AllowNull()]
        $Object,

        # Default to female
        [int]$Gender = 1,

        [int]$Id = -1
    )

    if ($Object) {
        # Does this need to be localized (male/female)?
        if ($Gender -eq 0) {
            $ret = $Object.gender_name.male
        }
        else {
            $ret = $Object.gender_name.female
        }
    }
    if (-not $ret) {
        $ret = "Unknown[$id]"
    }

    $ret
}