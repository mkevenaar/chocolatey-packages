$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.15/win/Opera_beta_95.0.4635.15_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.15/win/Opera_beta_95.0.4635.15_Setup_x64.exe'
  checksum       = 'a2cc1b18c086455bed9b3fab31e2658c11519780812307bdde60629338df228a'
  checksum64     = 'fb120e0560705f550c027814231e177471e993c4099365a4c38a90c7a494b93f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4635.15'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
