$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/85.0.4323.0/win/Opera_Developer_85.0.4323.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/85.0.4323.0/win/Opera_Developer_85.0.4323.0_Setup_x64.exe'
  checksum       = 'ea29df5a1fabcc4b76b96b9be97a05fb0fd4851865b5e816a89b4d130a3150c1'
  checksum64     = 'e4939d18465622bebc2784314fa81d8f7c79081a67661da81d7a4e84b5373a12'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4323.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
