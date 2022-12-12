$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/95.0.4632.0/win/Opera_Developer_95.0.4632.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/95.0.4632.0/win/Opera_Developer_95.0.4632.0_Setup_x64.exe'
  checksum       = '4ffa6e8456e0638c6be25b0c464a05bd4f8187b655da4610d30c7a1864c7d8d1'
  checksum64     = 'a76e7647bf8e3dae0f416100e1d13f828dbb47f158a35abea63c8389f779ff34'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4632.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
