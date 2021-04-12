$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/77.0.4023.0/win/Opera_Developer_77.0.4023.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/77.0.4023.0/win/Opera_Developer_77.0.4023.0_Setup_x64.exe'
  checksum       = '8596903ee911245433e72424d0f39092e3d7159916c3781fa77ab0bc2495d3f9'
  checksum64     = '742eb0fcf203c49f9c1a9ae57428918b064dff7a56f595c6cec0260ad8dc106f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4023.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
