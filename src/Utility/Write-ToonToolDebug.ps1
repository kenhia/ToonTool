# ----------------------------------------------------------------------------------------------------------------
# Copyright (c) Ken Hiatt. All rights reserved.
# Licensed under the MIT License.
#
# THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
# IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
# ----------------------------------------------------------------------------------------------------------------

function Write-ToonToolDebug {
    param(
        [Parameter(ValueFromPipeline)]
        $Message
    )
    process {
        if ($env:TOONTOOL_DEBUG) {
            $ts = (Get-Date).ToString('HH:mm:ss.fff')
            foreach ($m in $Message) {
                Write-Host "TTdbg:${ts}: " -ForegroundColor DarkCyan -NoNewline
                Write-Host $m -ForegroundColor Magenta
            }
        }
    }
}
Set-Alias -Name TTdbg -Value Write-ToonToolDebug