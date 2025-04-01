$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5489.0/win/Opera_Developer_119.0.5489.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5489.0/win/Opera_Developer_119.0.5489.0_Setup_x64.exe'
  checksum       = 'c17a7669fdc8543a88ec76c5e4cebb1a1fa802f8971ea783253f9d48475e4f8f'
  checksum64     = 'dc4562fdfb5edaff91923e6321f5cc65dfa73a8e86e122125c318c90ea8277c0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5489.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
