# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

function Get-UserInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Token,

        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    if ($Region -eq 'cn') {
        $urlbase = 'https://www.battlenet.com.cn'
    }
    else {
        $urlbase = "https://${Region}.battle.net"
    }
    $url = "$urlbase/oauth/userinfo"

    $authorization = @{ Authorization = "Bearer $Token" }
    Invoke-RestMethod -Method Get -Uri $url -Headers $authorization
}