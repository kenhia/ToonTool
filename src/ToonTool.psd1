@{
    RootModule           = 'ToonTool.psm1'
    ModuleVersion        = '0.0.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID                 = 'c9750163-1c4e-4b82-976b-92b97986e93d'
    Author               = 'Ken Hiatt'
    CompanyName          = 'Ken Hiatt'
    Copyright          = @'
Copyright (c) Ken Hiatt. All rights reserved.
This code is Licensed under the MIT License.
THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
'@
    Description          = 'Get info from Blizzard on my Toons'
    # PowerShellVersion = ''
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport    = @(
        'Get-GameData'
        'ConvertFrom-UnixTimestamp'
        'Get-BlizzardClientToken'
        'Get-BlizzardData'
        'Get-CharacterProfileSummary'
        # Export for ease of debugging; remove later
        'Get-BlizzardClientToken'
        'Get-GameDataUrl'
        'Get-UserOauth'
        '*'
    )
    CmdletsToExport      = @()
    VariablesToExport    = '*'
    AliasesToExport      = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData          = @{
        PSData = @{
            Tags = @('WoW', 'Toons', 'Alts')
            LicenseUri = 'https://ken-hiatt.mit-license.org/'
            # ProjectUri = ''
            # IconUri = ''
            # ReleaseNotes = ''
        } # End of PSData hashtable
    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

