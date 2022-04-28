$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/87.0.4390.8/win/Opera_beta_87.0.4390.8_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/87.0.4390.8/win/Opera_beta_87.0.4390.8_Setup_x64.exe'
  checksum       = '4294a04acc67d21afb3c1878fb800d41a722af263726827b9079a52f2859a468'
  checksum64     = '382e25dd0a4b50cb9532c2bee1bd23745d13f669aeecd95a9c8aca09d422e683'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '87.0.4390.8'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
