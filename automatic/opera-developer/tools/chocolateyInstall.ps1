$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3487.0/win/Opera_Developer_66.0.3487.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3487.0/win/Opera_Developer_66.0.3487.0_Setup_x64.exe'
  checksum       = '850ed62f0508a2f0a9cddbc14da525fd064cc4b99616d9a018003d509c1c359d'
  checksum64     = '308891da62edd118c84dd0eb6f94cdf50d5111550f29f17c1777f23444fedf13'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3487.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
