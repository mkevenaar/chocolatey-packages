$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/117.0.5383.0/win/Opera_Developer_117.0.5383.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/117.0.5383.0/win/Opera_Developer_117.0.5383.0_Setup_x64.exe'
  checksum       = '25b6ed40fbc481a43794cbf4dc5d46b85461128b70a12d6f29d269d7023b088b'
  checksum64     = '592eb7a564bf47a896275e6ca99685894d3d333857d0a233180add68b2f11db7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '117.0.5383.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
