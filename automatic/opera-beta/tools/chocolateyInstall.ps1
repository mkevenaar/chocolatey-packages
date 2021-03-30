$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.137/win/Opera_beta_75.0.3969.137_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.137/win/Opera_beta_75.0.3969.137_Setup_x64.exe'
  checksum       = 'a6d8c7b75c8c06a98ecd6b7a624a58117f39233cbb8c02695e694ffb2ef08581'
  checksum64     = '374d5ca6c9dc85e89c2ba9e567ff3480b61ea7930b325aae8d4188635af5cea9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3969.137'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
