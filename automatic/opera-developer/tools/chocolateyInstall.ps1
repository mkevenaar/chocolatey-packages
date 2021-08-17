$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/80.0.4150.0/win/Opera_Developer_80.0.4150.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/80.0.4150.0/win/Opera_Developer_80.0.4150.0_Setup_x64.exe'
  checksum       = '8647392b4005059979afc32b6778b5111934c1bd28bffe88e37e83af05466540'
  checksum64     = '02ee91c592c1e9c65d9cc082f61f19ca7aa906dfcde497e9097b3f7336bc4bbd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '80.0.4150.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
