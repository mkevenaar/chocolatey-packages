$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/100.0.4815.2/win/Opera_beta_100.0.4815.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/100.0.4815.2/win/Opera_beta_100.0.4815.2_Setup_x64.exe'
  checksum       = '7a3b75e538a9687a060074aab7d839c9fc9b72242ebff4168975dae0cc39cad6'
  checksum64     = '5f6f373b7870d9ce3c5848016e1a33862a673b2805f54ea4fd2b3ce221274933'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4815.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
