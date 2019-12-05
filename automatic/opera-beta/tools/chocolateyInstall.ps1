$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.7/win/Opera_beta_66.0.3515.7_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/66.0.3515.7/win/Opera_beta_66.0.3515.7_Setup_x64.exe'
  checksum       = '3b7e61353477c47c253846ece978584508c199db7f453cbb2fe62d3dc56e5b52'
  checksum64     = 'bbe6b3429d028b8bd71d0e06aa2ed6fbb79ed137f3bd58b3f0a45391cc6de77f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3515.7'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
