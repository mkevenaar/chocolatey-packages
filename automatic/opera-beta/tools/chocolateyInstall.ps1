$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.12/win/Opera_beta_106.0.4998.12_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/106.0.4998.12/win/Opera_beta_106.0.4998.12_Setup_x64.exe'
  checksum       = 'fc2e643000c4689ae8e2b653ed77b02b155a3c7a3a55547212226b42eb326912'
  checksum64     = 'b6f4986def01f19622f324fdd0073a61c9d8f8dcd73ba54856baeae3df3da0ea'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4998.12'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
