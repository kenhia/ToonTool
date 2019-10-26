# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

function Get-GameDataCachePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SubDir,
        [string]$Extension = '.json'
    )

    Join-Path -Path $Module.DataRoot -ChildPath ($SubDir+$Extension)
}