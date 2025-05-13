$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$pp = Get-PackageParameters

Set-AutoUpdate -Enable

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://updates.signal.org/desktop/signal-desktop-win-7.54.0.exe'
  checksum       = '3ea684ff4731ef94669523663d2f6299beae1b12e092bc94348657e3eea82fc5'
  checksumType   = 'sha256'
  softwareName   = 'Signal *'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

Install-DesktopShortcut
Set-SignalOptions

Register-Application "$toolsPath\signal.bat" signal
Write-Host "Application registered as signal"

if ($pp.NoAutoUpdate) { Write-Host "Disabling auto update"; Set-AutoUpdate -Disable }
