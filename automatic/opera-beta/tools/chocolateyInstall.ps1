$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/80.0.4170.11/win/Opera_beta_80.0.4170.11_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/80.0.4170.11/win/Opera_beta_80.0.4170.11_Setup_x64.exe'
  checksum       = 'b0e516ae6a6806b4168a13f60d0295fed30eb60d4abcccdab46ece13042a824e'
  checksum64     = '8f77fa170003e90cce086800888da5a83c989544e7bb4be3961c4d5742003f37'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '80.0.4170.11'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
