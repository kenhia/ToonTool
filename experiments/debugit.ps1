Import-Module -Name C:\src\ToonTool\src\ToonTool.psd1 -Force
$ktoons = Get-AccountCharacters
$ktoons[0] | Test-CharacterValid
