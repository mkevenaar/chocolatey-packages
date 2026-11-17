$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/141.0.6087.0/win/Opera_Developer_141.0.6087.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/141.0.6087.0/win/Opera_Developer_141.0.6087.0_Setup_x64.exe'
  checksum       = 'ccef1328baa2142180fbdea4e41ef243b2b62286118972b69f620d9033bf8ccc'
  checksum64     = 'fa0b12a666c3cc15d0b5f0c8aab5ff90b1995bc000969e5850cbf8bbfd0ee317'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '141.0.6087.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
