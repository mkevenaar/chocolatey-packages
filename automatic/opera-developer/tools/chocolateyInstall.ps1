$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/106.0.4993.0/win/Opera_Developer_106.0.4993.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/106.0.4993.0/win/Opera_Developer_106.0.4993.0_Setup_x64.exe'
  checksum       = '03176d4e0ad738e883620b9c2fe1ef31b2b28d9f55ee7c13f1d9ca65fef673cc'
  checksum64     = '5a3e0998e2c5bc7a8d4a5d93b8ad8290ef68b04aa7b33c040acd252e90eddb0a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4993.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
