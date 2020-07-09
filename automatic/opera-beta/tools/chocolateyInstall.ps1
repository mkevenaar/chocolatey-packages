$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.21/win/Opera_beta_70.0.3728.21_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/70.0.3728.21/win/Opera_beta_70.0.3728.21_Setup_x64.exe'
  checksum       = 'f04b24122e3d287e4b6d15b4839aea9c01c67764555df7740b367c729eb9cd9d'
  checksum64     = 'aee8fe3e4f90f026bc9ef8779b49c9cbeacb5ff6df3acd22e4b78c2d448883e4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3728.21'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
