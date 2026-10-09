$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  PackageName    = 'telegram.portable'
  file           = "$toolsPath\td-portable-win-x86-7.3.0_x32.zip"
  file64         = "$toolsPath\td-portable-win-x64-7.3.0_x64.zip"
  Destination    = "C:\tools\telegram.portable"
}

Get-ChocolateyUnzip @packageArgs

$Shortcut = Get-ChildItem $packageArgs['Destination'] -Recurse -Include Telegram.exe| Select-Object -First 1
Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Telegram.lnk" $Shortcut -WorkingDirectory $packageArgs['Destination']
