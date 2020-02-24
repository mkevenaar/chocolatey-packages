$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/68.0.3609.0/win/Opera_Developer_68.0.3609.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/68.0.3609.0/win/Opera_Developer_68.0.3609.0_Setup_x64.exe'
  checksum       = '761753466ebcb31b08e6873c2c4b4f5ae290092fa046b23e3111ba86d3190b18'
  checksum64     = 'f291a5ac323253880b1d2073953ccda2c33382d2a949229c0161888ba2e17cc1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3609.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
