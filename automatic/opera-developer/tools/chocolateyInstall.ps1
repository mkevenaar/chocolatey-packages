$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5566.0/win/Opera_Developer_121.0.5566.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5566.0/win/Opera_Developer_121.0.5566.0_Setup_x64.exe'
  checksum       = 'fced3cf476b3ec3f3a62c05c53c12b29d0bfd2deb8a04d348bcbe6212067dbd7'
  checksum64     = 'af1e340eca9f6cb2921a61499e366b660794bf81badff44873517b1a1eb3f1c9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5566.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
