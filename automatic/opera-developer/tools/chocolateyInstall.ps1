$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/97.0.4711.0/win/Opera_Developer_97.0.4711.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/97.0.4711.0/win/Opera_Developer_97.0.4711.0_Setup_x64.exe'
  checksum       = '46816703f644b092723bcc9bdaca2d0064e7b83884d1eb180a6c68993935a8a3'
  checksum64     = '5403d0f77b32b32cd3513b6e884c64554482150affee99ac376df04e5c06bb35'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4711.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
