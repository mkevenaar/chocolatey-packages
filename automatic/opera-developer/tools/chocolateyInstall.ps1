$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/102.0.4871.0/win/Opera_Developer_102.0.4871.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/102.0.4871.0/win/Opera_Developer_102.0.4871.0_Setup_x64.exe'
  checksum       = '9a3c9ab4ba8bbcf1ed2e1cce8cd1cbc151590c847acf50db91860cc4569d9f74'
  checksum64     = '14910b705584ff1e76ef7f353cef0066d9e54dfff2c03d783dd304ed8c5b77fc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4871.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
