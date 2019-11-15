#
# curl -u MYCLIENTID:MYSECRET -d grant_type=client_credentials https://us.battle.net/oauth/token
#
$credPlain = '{0}:{1}' -f $env:BLIZ_CLIENT_ID, $env:BLIZ_API_SECRET
$utf8Encoding = [System.Text.UTF8Encoding]::new()
$credBytes = $utf8Encoding.GetBytes($credPlain)
$base64auth = [Convert]::ToBase64String($credBytes)

$splat = @{
    Method          = 'POST'
    Uri             = 'https://us.battle.net/oauth/token'
    ContentType     = 'application/x-www-form-urlencoded'
    Body            = 'grant_type=client_credentials'
    Headers         = @{Authorization = ('Basic {0}' -f $base64auth) }
    UseBasicParsing = $true
}

try {
    $result = Invoke-WebRequest @splat
    if ($result.StatusCode -eq 200) {
        $result.Content | ConvertFrom-Json
    }
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $status = $_.Exception.Response.StatusCode
    Write-Warning "Bad status code ($statusCode) $status"
}
