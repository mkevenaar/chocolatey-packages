$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/79.0.4128.0/win/Opera_Developer_79.0.4128.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/79.0.4128.0/win/Opera_Developer_79.0.4128.0_Setup_x64.exe'
  checksum       = 'a68d386b44d6263b7753998e889c9ca805c57e39f4f802fdff02f6a0f1aa487d'
  checksum64     = '8ccd5ce1bb323296691ec203e29ae0f0b960cfb3dedad6dd3a264f2291222263'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4128.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
