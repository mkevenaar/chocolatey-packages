$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.22/win/Opera_beta_63.0.3368.22_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/63.0.3368.22/win/Opera_beta_63.0.3368.22_Setup_x64.exe'
  checksum       = '9dd88b54a8f55c17c1f487e564908ee999cbea6724130d9c4524e5ea404a132b'
  checksum64     = '93332e086b2fcb826aba1a80b2347439167623b2b1af1cbf88594d3c95c2aefd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3368.22'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
