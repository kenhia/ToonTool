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
    throw "Not working yet"

    $VerbosePreference = 'Continue'

    ($bnetClient, $bnetSecret) = Get-ClientCredential

    # App Secret - move into a envVar or something
    $state = 'sIbGUXY1d$JI56FeOBBXUfd&x7vCgefC5hx65Q7kpl'
    # TODO: FIX REGION BIT and CN different URL
    $url = 'https://us.battle.net/oauth/authorize'
    $url += "?client_id=$bnetClient"
    $url += "&redirect_uri=https://localhost"
    $url += "&scope=wow.profile"
    $url += "&state=$state"
    Show-OAuthWindow
    $regex = '(?<=code=)(.*)(?=&)'
    $authCode = ($uri | Select-String -Pattern $regex).Matches[0].Value
    Write-Verbose "got an auth code: $authCode"
}

function Show-OAuthWindow {
    $VerbosePreference = 'Continue'
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
        Write-Verbose "URI: $($web.Url.AbsoluteUri)"
        $Global:uri = $web.Url.AbsoluteUri
        if ($Global:uri -match "error=[^&]*|code=[^&]*") { $form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocCompleted)
    $form.Controls.Add($web)
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}



<#
function Get-UserOauth {
    [CmdletBinding()]
    param ()

    $VerbosePreference = 'Continue'

    ($bnetClient, $bnetSecret) = Get-ClientCredential

    # K: should this be redirect_uri for WoW?
    $Global:clientreq = ConvertFrom-Json '{"redirect_uris":["https://localhost"]}'
    $Global:clientreq = ConvertFrom-Json '{"redirect_uri":"https://localhost"}'
    $clientres = ConvertFromJson @"
{
    "client_id": $bnetClient,
    "client_secret": $bnetSecret
}
"@

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Web

    $form = [Windows.Forms.Form]::new()
    $form.Width = 640
    $form.Height = 480
    $web = [Windows.Forms.WebBrowser]::new()
    $web.Size = $form.ClientSize
    $web.Anchor = "Left,Top,Right,Bottom"
    $form.Controls.Add($web)
    # Global for collecting authorization code response
    $Global:redirect_uri = $null
    # add handler for the embedded browser's Navigating event
    $web.add_Navigating({
        Write-Verbose "Navigating $($_.Url)"
        $uri = [uri] $Global:clientreq.redirect_uri
        if ($_.Url.Authority -eq $uri.Authority) {
            # Collect authorization response in a global
            $Global:redirect_uri = $_.Url
            # Cancel event and close browser window
            $form.DialogResult = "OK"
            $form.Close()
            $_.Cancel = $true
        }
    })
}
#>