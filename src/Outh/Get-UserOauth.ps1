# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

<#
.SYNOPSIS
    Get authorization to get user information

.NOTES
    No idea how to do this with PowerShell other than on Windows.
#>

function Get-UserOauth {
    [CmdletBinding()]
    param()
    # throw "Not working yet"

    $VerbosePreference = 'Continue'

    ($bnetClient, $bnetSecret) = Get-ClientCredential

    # Generate a random state to check
    $state = Get-StateSecret

    # TODO: FIX REGION BIT and CN different URL
    $url = 'https://us.battle.net/oauth/authorize'
    $url += "?client_id=$bnetClient"
    $url += "&redirect_uri=http://localhost"
    $url += "&scope=wow.profile"
    $url += "&state=$state"
    $url += "&response_type=code"
    Show-OAuthWindow
    $regex = '(?<=code=)(.*)(?=&)'
    $authCode = ($uri | Select-String -Pattern $regex).Matches[0].Value

    if ($uri -notmatch 'state=([^&]*)' -or $Matches[1] -ne $state) {
        # State doesn't match
        throw 'Get-UserOauth - state secret did not match in return.'
    }
    # $Global:dbgAuthUri = $uri
    Write-Verbose "got an auth code: $authCode"
    if ($authCode.Length -gt 20) {
        # send token request
        $tokenrequest = @{
            grant_type   = "authorization_code"
            redirect_uri = "http://localhost"
            code         = $authCode
        }
        Write-Verbose "token-request: $([pscustomobject]$tokenrequest)"
        $basic = @{ "Authorization" = ("Basic", [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(($bnetClient, $bnetSecret -join ":"))) -join " ") }
        $token = Invoke-RestMethod -Method Post -Uri 'https://us.battle.net/oauth/token' -Headers $basic -Body $tokenrequest
        Write-Verbose "token-response: $($token)"
    }
    if ($token) {
        return $token
    }
}

function Get-StateSecret {
    <#
    .SYNOPSIS
        Gets a random string to use for state
    .NOTES
        Yes, I was amusing myself when naming this function
    #>

    $c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz'
    $sb = [System.Text.StringBuilder]::new(44)
    for ($i = 0; $i -lt 40; $i++) {
        [void]$sb.Append($c[(Get-Random -Maximum $c.Length)])
    }
    $sb.ToString()
}

function Show-OAuthWindow {
    #$VerbosePreference = 'Continue'
    Add-Type -AssemblyName System.Windows.Forms
    $form = [System.Windows.Forms.Form]::new()
    $form.Width = 440
    $form.Height = 640
    $web = [System.Windows.Forms.WebBrowser]::new()
    $web.Size = $form.ClientSize
    $web.Anchor = "Left,Top,Right,Bottom"
    $web.Url = $url #"https://www.bing.com"
    $DocCompleted = {
        Write-Verbose "In Doc Completed"
        Write-Verbose "url [$url]"
        Write-Verbose "URI: $($web.Url.AbsoluteUri)"
        $Global:uri = $web.Url.AbsoluteUri
        if ($Global:uri -match "error=[^&]*|code=[^&]*") { $form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocCompleted)
    $form.Controls.Add($web)
    $form.Add_Shown( { $form.Activate() })
    $form.ShowDialog() | Out-Null
}
