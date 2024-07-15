$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/113.0.5227.0/win/Opera_Developer_113.0.5227.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/113.0.5227.0/win/Opera_Developer_113.0.5227.0_Setup_x64.exe'
  checksum       = 'b64966db2e5988c1d7934697e128ab2afdff1d69d9fc9197d72417e1a30126f8'
  checksum64     = '2aa5d48df00c914ed7566bc2570e2d6ff91a8cd551758474447caad3ca780fdc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '113.0.5227.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
