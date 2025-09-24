$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$pp = Get-PackageParameters

Set-AutoUpdate -Enable

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://updates.signal.org/desktop/signal-desktop-win-7.72.0.exe'
  checksum       = '5ce5c5e4600437870c0b9c736da6fda1bdacf5bea48a73089da72e4524734dda'
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
