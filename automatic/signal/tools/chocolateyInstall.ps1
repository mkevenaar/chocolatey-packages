$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$pp = Get-PackageParameters

Set-AutoUpdate -Enable

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://updates.signal.org/desktop/signal-desktop-win-8.4.0.exe'
  checksum       = 'a5b4e27f7ecd1800d89c865c3e6d025a4de82d9b02a03ac5116108c4ac59e9ea'
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
