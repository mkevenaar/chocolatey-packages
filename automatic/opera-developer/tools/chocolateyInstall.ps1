$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/78.0.4072.0/win/Opera_Developer_78.0.4072.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/78.0.4072.0/win/Opera_Developer_78.0.4072.0_Setup_x64.exe'
  checksum       = '56a73a60e9a3a6ffd47ad9cf7a2ca91d18e7bf8459886028901771b7c84c2e5d'
  checksum64     = '65bc7f73849d1fad21f8b3ee093068773aeb159d51e1351b85ec702bc1ef12ba'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4072.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
