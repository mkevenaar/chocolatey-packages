$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/117.0.5378.0/win/Opera_Developer_117.0.5378.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/117.0.5378.0/win/Opera_Developer_117.0.5378.0_Setup_x64.exe'
  checksum       = '8982ba22a683f34d54a02192c58718e8f1892f8ace49c5e263ff561d60b22f54'
  checksum64     = '5b44f55cb388d41f7666c9f1dbccaac1eecf81fce72c43854dc8c42ce3d83f6f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '117.0.5378.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
