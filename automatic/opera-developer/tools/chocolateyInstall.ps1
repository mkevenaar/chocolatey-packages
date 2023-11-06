$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/106.0.4977.0/win/Opera_Developer_106.0.4977.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/106.0.4977.0/win/Opera_Developer_106.0.4977.0_Setup_x64.exe'
  checksum       = 'c73ec5aca1e238dd836301ec6fabbf9c34aefd09a5125e689d9c6378c43626cd'
  checksum64     = 'e5208e60d51a17c368586d9d3f43389ff2f9bf763bc2d4a2905c85b400563e88'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4977.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
