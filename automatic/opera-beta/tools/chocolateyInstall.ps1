$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.14/win/Opera_beta_75.0.3969.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.14/win/Opera_beta_75.0.3969.14_Setup_x64.exe'
  checksum       = '48335f9727bf5f67436a5e3c7aaf476c8ca7b3b72892e4b60dfbd2dc03f7e0ed'
  checksum64     = 'd2f9bc7d05e29940b667cf235fe0f72de0715988616008e2653c31b4c8ab7c85'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3969.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
