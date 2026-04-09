$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/131.0.5863.0/win/Opera_Developer_131.0.5863.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/131.0.5863.0/win/Opera_Developer_131.0.5863.0_Setup_x64.exe'
  checksum       = '3e3c713f85aba212d21f47dbad117a1e0be2be0a1376cf7d5af331f16b5630ee'
  checksum64     = 'ce31d9ba80cbe02437e4c543699d9c346acdc5313bd4874eee7b629160c4f07c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '131.0.5863.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
