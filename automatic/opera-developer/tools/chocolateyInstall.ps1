$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/79.0.4135.0/win/Opera_Developer_79.0.4135.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/79.0.4135.0/win/Opera_Developer_79.0.4135.0_Setup_x64.exe'
  checksum       = '2ed0c20e01f3a230d32688c99ae80f56ff75d8980dbcd1954a862b2a18432e0c'
  checksum64     = '5a56b3169fcaebda72480cc0b629cf256a39604d6b90d1f217e93437acc379a9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4135.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
