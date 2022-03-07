$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/86.0.4351.0/win/Opera_Developer_86.0.4351.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/86.0.4351.0/win/Opera_Developer_86.0.4351.0_Setup_x64.exe'
  checksum       = 'b1feff5f6ab4d012664f9ca95734a093b4543a09c848e346af33addbd6d72445'
  checksum64     = '698a36db62ce63c8bb3bfc7a05f8579f8bf05e05aa7f0eb5c1e4b4c38fbf7903'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '86.0.4351.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
