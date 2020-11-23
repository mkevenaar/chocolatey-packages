$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/74.0.3883.0/win/Opera_Developer_74.0.3883.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/74.0.3883.0/win/Opera_Developer_74.0.3883.0_Setup_x64.exe'
  checksum       = '32d13d85bad9a164727acc401a3c4ad5bb8aa44ba2c2c49727256b63d07fa0f9'
  checksum64     = '86c2ce0a22fb7eec04b48ec9061dbacda9dc50ce5d281e3f1b27011166992d87'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '74.0.3883.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
