$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/122.0.5638.0/win/Opera_Developer_122.0.5638.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/122.0.5638.0/win/Opera_Developer_122.0.5638.0_Setup_x64.exe'
  checksum       = '7ab8c3d50cd377f78d4e0243ead13ffe48a898d6d2681fb09110e4926f237ba6'
  checksum64     = 'b22543ebee7801ce7de109d5373f7d0bedcf9ae0812276ffee7d90dd7c1bb0e3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '122.0.5638.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
