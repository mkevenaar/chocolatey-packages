$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.12/win/Opera_beta_95.0.4635.12_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/95.0.4635.12/win/Opera_beta_95.0.4635.12_Setup_x64.exe'
  checksum       = 'a2ed0e8a4054294cdf57209117b76d538d617f2d5ede690478fa5a693c39fba4'
  checksum64     = 'a698ecfd5b9a592bc16210d00b0d4790d830415fe48efb9f74a3ce4cfaffdd96'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '95.0.4635.12'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
