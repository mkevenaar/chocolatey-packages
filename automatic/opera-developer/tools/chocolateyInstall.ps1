$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3430.0/win/Opera_Developer_65.0.3430.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3430.0/win/Opera_Developer_65.0.3430.0_Setup_x64.exe'
  checksum       = 'e851aa76aea5a2d31786d3b4fe061121d9676af1d8d263fa449cbe710d494193'
  checksum64     = 'bb44804084dec2d3b37ac7012f66f628ba20a429d3ebe42cac99b2715fbdc422'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3430.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
