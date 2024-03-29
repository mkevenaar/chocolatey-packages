$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/110.0.5120.60797/win/Opera_Developer_110.0.5120.60797_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/110.0.5120.60797/win/Opera_Developer_110.0.5120.60797_Setup_x64.exe'
  checksum       = 'bb57cbb683416b283fdb47f657c07159d6a2339bbc463679bdd88934e42cb0a5'
  checksum64     = '680d56d427ead1475d2ccd767e9b9520953670c930fe456935c1fdbd7d9620c7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '110.0.5120.60797'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
