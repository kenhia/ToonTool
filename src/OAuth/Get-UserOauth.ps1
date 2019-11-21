# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Get authorization to get user information

.NOTES
    No idea how to do this with PowerShell other than on Windows.
    This does not work on PS Core :-(
#>

function Get-UserOauth {
    [CmdletBinding()]
    param(
        [ValidateSet('us', 'eu', 'kr', 'tw', 'cn')]
        $Region = 'us'
    )

    ($bnetClient, $bnetSecret) = Get-ClientCredential

    # Generate a random state to check
    $state = Get-StateSecret

    # 'cn' requires special handling
    if ($Region -eq 'cn') {
        $urlbase = 'https://www.battlenet.com.cn'
    }
    else {
        $urlbase = "https://${Region}.battle.net"
    }
    $url = Join-UrlData -Url "$urlbase/oauth/authorize" -Params @(
        "client_id=$bnetClient"
        "redirect_uri=http://localhost"
        "scope=wow.profile"
        "state=$state"
        "response_type=code"
    )
    $null = $url # Shut up PSAnalyzer; variable is used by Show-OAuthWindow

    # "returns" value to $Global:OAUTHuri, need to use it and then clean up the global
    Show-OAuthWindow

    if ($OAUTHuri -match 'code=([^&]*)') {
        $authCode = $Matches[1]
    }
    else {
        # Did not get a code
        throw 'Get-UserOauth - did not get a code'
    }
    if ($OAUTHuri -notmatch 'state=([^&]*)' -or $Matches[1] -ne $state) {
        # State doesn't match
        throw 'Get-UserOauth - state secret did not match in return.'
    }

    # Done with OAUTHuri
    if (-not $env:TOONTOOL_DEBUG) {
        $Global:OAUTHuri = $null
        Remove-Variable -Scope Global -Name OAUTHuri
    }

    Write-Verbose "got an auth code: $authCode"
    if ($authCode.Length -gt 20) {
        # send token request
        $tokenrequest = @{
            grant_type   = "authorization_code"
            redirect_uri = "http://localhost"
            code         = $authCode
        }
        $basic = @{ "Authorization" = ("Basic", [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(($bnetClient, $bnetSecret -join ":"))) -join " ") }
        $token = Invoke-RestMethod -Method Post -Uri 'https://us.battle.net/oauth/token' -Headers $basic -Body $tokenrequest
    }
    if ($token) {
        return $token
    }
}


function Show-OAuthWindow {
    #$VerbosePreference = 'Continue'
    Add-Type -AssemblyName System.Windows.Forms
    $form = [System.Windows.Forms.Form]::new()
    $form.Width = 500
    $form.Height = 640
    $web = [System.Windows.Forms.WebBrowser]::new()
    $web.Size = $form.ClientSize
    $web.Anchor = "Left,Top,Right,Bottom"
    $web.Url = $url
    $DocCompleted = {
        $Global:OAUTHuri = $web.Url.AbsoluteUri
        if ($Global:OAUTHuri -match "error=[^&]*|code=[^&]*") { $form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocCompleted)
    $form.Controls.Add($web)
    $form.Add_Shown( { $form.Activate() })
    $form.ShowDialog() | Out-Null
}
