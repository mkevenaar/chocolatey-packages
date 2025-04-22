$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/120.0.5510.0/win/Opera_Developer_120.0.5510.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/120.0.5510.0/win/Opera_Developer_120.0.5510.0_Setup_x64.exe'
  checksum       = 'd3a26a97552bd82b5ccafd81287333f9489c3bdbd3ce6db00e9b872c485f182f'
  checksum64     = '5f569fc6124fcb376eabf34bc4aad952960dfa83e4bdb4e9f82e020e4ba1f640'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '120.0.5510.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
