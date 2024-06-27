$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/113.0.5210.0/win/Opera_Developer_113.0.5210.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/113.0.5210.0/win/Opera_Developer_113.0.5210.0_Setup_x64.exe'
  checksum       = '161efbd3324830fbec2d2d2b7f9ecf833974f3d80773e47d7c3423c68873f6f6'
  checksum64     = 'c6731f54aea6787ff43ea2de3a0e8f1a59faa4196cf513af21d7c15193d85fd5'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '113.0.5210.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
