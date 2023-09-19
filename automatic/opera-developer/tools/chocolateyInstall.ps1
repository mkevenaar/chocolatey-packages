$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/103.0.4928.0/win/Opera_Developer_103.0.4928.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/103.0.4928.0/win/Opera_Developer_103.0.4928.0_Setup_x64.exe'
  checksum       = 'abaa530a3173eb570bfc9348c95a8902df3b5cf2067c112beb9128a8b8631c42'
  checksum64     = '7511764f4de1a43466c9314f0e306900620976d9c7b3764c52997a1423da2e6c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4928.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
