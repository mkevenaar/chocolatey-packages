$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/82.0.4227.4/win/Opera_beta_82.0.4227.4_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/82.0.4227.4/win/Opera_beta_82.0.4227.4_Setup_x64.exe'
  checksum       = 'ebb50fa5253635585814fecad22adb6f85c2531bdb8e1a96e1e7a273cd4c5179'
  checksum64     = 'e412c359170eb77d01d0733dbc7d36ae2bf5a377c1f0be22844527a9ec05c747'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4227.4'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
