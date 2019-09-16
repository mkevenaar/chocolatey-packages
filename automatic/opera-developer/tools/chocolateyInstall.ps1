$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3443.0/win/Opera_Developer_65.0.3443.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3443.0/win/Opera_Developer_65.0.3443.0_Setup_x64.exe'
  checksum       = 'bfecdf59fa20ba953fb1e87bd315ce82212c5eafa83f6c38adc3bc6d9eeeb38b'
  checksum64     = 'd81f8f05d0bd03c394d2de9c4e81e421b129a73f1d8e78f00188bd821fdac970'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3443.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
