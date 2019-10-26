# -----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Adds dynamic parameters for items that are in the url with the patter {param}

.DESCRIPTION
    Parameters added this way are mandatory. The tab-completion works but is a bit wonky.
#>

function Get-WowDynamicParam {
    [CmdletBinding()]
    param (
        [string]$Api
    )

    $parameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

    if ($WowApiMap.ContainsKey($Api + '')) {
        $urlBit = $WowApiMap.$Api.url
        $args = $urlBit |
            Select-String '{(?<param>[^}]+)}' -AllMatches |
            ForEach-Object -MemberName matches |
            ForEach-Object -MemberName value
        if ($args.Count -gt 0) {
            foreach ($a in $args) {
                # strip the curlies
                $aName = $a.Substring(1, $a.Length - 2)
                $argAttr = [System.Management.Automation.ParameterAttribute]::new()
                $argAttr.Mandatory = $true
                $argAttr.Position = $pos
                $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $attributeCollection.Add($argAttr)
                $argParam = [System.Management.Automation.RuntimeDefinedParameter]::new($aName, [string], $attributeCollection)
                $parameterDictionary.Add($aName, $argParam)
            }
        }
    }
    return $parameterDictionary
}
