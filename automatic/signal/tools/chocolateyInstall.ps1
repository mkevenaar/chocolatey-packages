$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$pp = Get-PackageParameters

Set-AutoUpdate -Enable

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://updates.signal.org/desktop/signal-desktop-win-7.50.0.exe'
  checksum       = '62038bb62144e8fcb93ea6b9fbdf22dc47b86c3751c41ccef0385d71e9ed1cee'
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
