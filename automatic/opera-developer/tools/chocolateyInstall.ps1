$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/124.0.5670.0/win/Opera_Developer_124.0.5670.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/124.0.5670.0/win/Opera_Developer_124.0.5670.0_Setup_x64.exe'
  checksum       = '9bb677d5a9d1dc3a0f081d207ee5333092b92388197ed7f48404ee004cf523be'
  checksum64     = 'fd9a1d0c7ec44e2cecb15c5b1ed25e48f47752a1232bed2f91c3c7221befc4f9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '124.0.5670.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
