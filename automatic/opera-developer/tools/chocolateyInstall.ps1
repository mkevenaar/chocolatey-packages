$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/122.0.5615.0/win/Opera_Developer_122.0.5615.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/122.0.5615.0/win/Opera_Developer_122.0.5615.0_Setup_x64.exe'
  checksum       = 'ae4322cb90c567d3d313c60b3878d384bb0a2c59c6f4bdd9f0456f100582d63e'
  checksum64     = '1f3fa77964e130f09f15c0374a2d4ab95a2cbf58dd4d94d16396a6a3f3d22756'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '122.0.5615.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
