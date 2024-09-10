$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/115.0.5285.0/win/Opera_Developer_115.0.5285.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/115.0.5285.0/win/Opera_Developer_115.0.5285.0_Setup_x64.exe'
  checksum       = '7cba6c3c513b30cec1ed29083314b0010aff9724f58518b4f38d9a466a38a147'
  checksum64     = 'e0eae48d711bf7993efd70161e7697f07c1adb5d2ae45b2b9bc3e8efb5940acf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '115.0.5285.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
