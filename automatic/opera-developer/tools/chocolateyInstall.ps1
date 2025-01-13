$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/118.0.5411.0/win/Opera_Developer_118.0.5411.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/118.0.5411.0/win/Opera_Developer_118.0.5411.0_Setup_x64.exe'
  checksum       = 'c6a5e0f307924e8d5379affc4c634312586a847c353871a7ccb8863b9a6ef3ea'
  checksum64     = '23f4b242a5a65e61a8c5a430555f64d48c51eaa8bd8d949e2b5beec95b6db7eb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '118.0.5411.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
