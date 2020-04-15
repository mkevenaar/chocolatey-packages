$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.41/win/Opera_beta_68.0.3618.41_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/68.0.3618.41/win/Opera_beta_68.0.3618.41_Setup_x64.exe'
  checksum       = '91131cb0eb9d73f458d830f17b3f2fcd9fc6f3ee69444307166c8167b5a3d786'
  checksum64     = '2616d7d7b19ff78b4655acfdcd46e895d3d4da0b610f607f32c8e1121cd95bc4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3618.41'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
