$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.46/win/Opera_beta_78.0.4093.46_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/78.0.4093.46/win/Opera_beta_78.0.4093.46_Setup_x64.exe'
  checksum       = '97eb0dbdd7701bf0f9f79675a65a538ec59a2812f694ff1c67d7f18f7d0ee185'
  checksum64     = '181d984230cf05c0c0fa8593c233b1439fec45a4c6a2eab51540c3091866a387'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4093.46'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
