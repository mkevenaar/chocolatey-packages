$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/105.0.4970.10/win/Opera_beta_105.0.4970.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/105.0.4970.10/win/Opera_beta_105.0.4970.10_Setup_x64.exe'
  checksum       = 'baf1d5fd5b099fe00fe0cdce77c7087e741aab60dca60fd4ab9a9a6bec62a634'
  checksum64     = 'fe953ee23e1fc8a713631af340533175dc7ab53f3b706c23d981a4fcdf2f810c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '105.0.4970.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
