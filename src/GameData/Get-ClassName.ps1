# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Converts a class ID to the class name

.NOTES
    Realized as I was writing this that I need to set region and locale...

    I'm starting to waffle a bit on how I want to handle region and locale. I think I want the ability to set it
    once for a series of operations so that scripts don't have to include the params each time. Alternatively a
    consumer could do something like:

        $reglocSplat = @{ Region = 'us'; Locale = 'en_US' }

    and then when making calls do:

        Get-WowData -Api $playableClassesIndex @reglocSplat
#>

function Get-ClassName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('ID')]
        $ClassId
    )

    $playableClasses = Get-WowData -Api PlayableClassesIndex
    $class = $playableClasses.classes | where id -EQ $ClassId
    if ($class) {
        $class.name
    }
    else {
        "UnknownClass($ClassId)"
    }
}