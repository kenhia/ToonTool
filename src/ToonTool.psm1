# -------------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# -------------------------------------------------------------------------------------------------------------------

$ps1Files = Get-ChildItem "$PSScriptRoot\*.ps1" -Recurse
foreach ($f in $ps1Files) {
    if ($f.Name.StartsWith('PLAY')) { continue }
    . $f.FullName
}

$Script:Module = @{
    DataRoot = $null
}

$dataRootTmp = Join-Path -Path $PSScriptRoot -ChildPath ..\.data
if (-not (Test-Path -Path $dataRootTmp)) {
    Write-Host "DataRoot not created; creating..." -ForegroundColor DarkYellow -NoNewline
    mkdir -Path $dataRootTmp | Out-Null
    if (Test-Path -Path $dataRootTmp) {
        Write-Host 'successful' -ForegroundColor DarkGreen
    }
    else {
        Write-Host 'failed' -ForegroundColor Red
        throw "Could not create data directory $dataRootTmp"
    }
    Write-Host "DataRoot is set to: $($Module.DataRoot)" -ForegroundColor Cyan
}
$Module.DataRoot = Resolve-Path -Path $dataRootTmp

Remove-Variable -Name dataRootTmp
