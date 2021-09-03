$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.15/win/Opera_beta_79.0.4143.15_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/79.0.4143.15/win/Opera_beta_79.0.4143.15_Setup_x64.exe'
  checksum       = 'b8f34c5472bd971f136c0f06f86e35e2bad9759f976ec27de5958094e409c550'
  checksum64     = '9d29f352c474dd98a207a82762cd3b868af3f102e2c9cac4ca5e1390b2a3c4be'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4143.15'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
