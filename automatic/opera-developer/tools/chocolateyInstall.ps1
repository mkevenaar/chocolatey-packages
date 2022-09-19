$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/92.0.4547.0/win/Opera_Developer_92.0.4547.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/92.0.4547.0/win/Opera_Developer_92.0.4547.0_Setup_x64.exe'
  checksum       = 'bd1d2223b7a7b62da025fb0498811d0680665140500ac609cc999bac53547735'
  checksum64     = '9b789ac676494aa2031219032ee081b40d01215f7e38bdbd3353db41a453ccbc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4547.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
