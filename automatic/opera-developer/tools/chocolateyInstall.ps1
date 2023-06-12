$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/101.0.4829.0/win/Opera_Developer_101.0.4829.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/101.0.4829.0/win/Opera_Developer_101.0.4829.0_Setup_x64.exe'
  checksum       = '4938204b97bf302714a2fa9fc95885c086848f01d5df7857004693528af494a3'
  checksum64     = '73ddfd35dc0c05a81f986d343b4a1307d894d4479b9b74e7e1ece211a48a106a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4829.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
