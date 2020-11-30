$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3890.0/win/Opera_Developer_74.0.3890.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3890.0/win/Opera_Developer_74.0.3890.0_Setup_x64.exe'
  checksum       = '913649bdde3f75648a92411bb1a60f8c871bc38ccefbb2e51cc98819b2552f83'
  checksum64     = '3f778573ede9eba531bcaf14e22c4ca4e6ceb7080147d9763e4e69bee92cd7fd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3890.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
