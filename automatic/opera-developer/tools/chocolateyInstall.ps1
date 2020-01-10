$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/67.0.3564.0/win/Opera_Developer_67.0.3564.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/67.0.3564.0/win/Opera_Developer_67.0.3564.0_Setup_x64.exe'
  checksum       = '7aec866a2da2684c2ab1ec25370583347ed89dda8dd265031c30ccfaf8d5eea4'
  checksum64     = 'cf63cfd21b468fdb17558d49b28bc7b125136b3256b8ac1f083747aefd8763af'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '67.0.3564.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
