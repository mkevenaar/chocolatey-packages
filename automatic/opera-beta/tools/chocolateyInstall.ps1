$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.10/win/Opera_beta_95.0.4635.10_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.10/win/Opera_beta_95.0.4635.10_Setup_x64.exe'
  checksum       = '28697ac153d5a2c1690997d89d805bc00a2cae8fb7baea9be6b9bc1ee38f5ac2'
  checksum64     = '3bd1083a6133f293d417b2d2457557b8f244b4015bb6f6d52965acd2b26c74cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4635.10'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
