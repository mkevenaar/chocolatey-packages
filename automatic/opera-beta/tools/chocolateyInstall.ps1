$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.51/win/Opera_beta_63.0.3368.51_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.51/win/Opera_beta_63.0.3368.51_Setup_x64.exe'
  checksum       = 'e98dde4b43aefbff4c71e7f987fb2fbf0d10f1915c7138cfe2db5adfae18d462'
  checksum64     = '077efff5bcb07b7dda0e8ff62f03d79939e158b871beee85eada500dcfb4dd1a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3368.51'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
