$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/112.0.5186.0/win/Opera_Developer_112.0.5186.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/112.0.5186.0/win/Opera_Developer_112.0.5186.0_Setup_x64.exe'
  checksum       = '00f717781925e66b95477d2f97b97003342c09921d46cce4d4e8bf83bee5bd2c'
  checksum64     = '9710ddcf6dc85199056f2a71b3a39b2c0f0b7e72dcea729fd7ee7dd7bc5e004d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '112.0.5186.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
