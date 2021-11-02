$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/82.0.4226.0/win/Opera_Developer_82.0.4226.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/82.0.4226.0/win/Opera_Developer_82.0.4226.0_Setup_x64.exe'
  checksum       = 'df31fd6a1f81766e0c9522af3e492363c7776b11d6e600fa3c35dd382d4418d9'
  checksum64     = '6ab6048f82ed292e66eebd60d1bb5b58f400ed6bb508840532ec277f4f8d7bf0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4226.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
