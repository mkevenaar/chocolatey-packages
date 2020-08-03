$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/71.0.3770.0/win/Opera_Developer_71.0.3770.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/71.0.3770.0/win/Opera_Developer_71.0.3770.0_Setup_x64.exe'
  checksum       = '7d20a12cacec4b19e0ce537de37066580704dc4d8524a94ceff820a27f71f9be'
  checksum64     = '1de638ab386a8a32d08167a33014f151b4d2b0bce20ecf5e61f60ec8d0b55a95'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '71.0.3770.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
