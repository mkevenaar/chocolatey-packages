$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/120.0.5524.0/win/Opera_Developer_120.0.5524.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/120.0.5524.0/win/Opera_Developer_120.0.5524.0_Setup_x64.exe'
  checksum       = 'd7900ab06ca0c82080a3b714c41ab6ab9157cebe278e3b8bd0fa268749860c85'
  checksum64     = 'dfe1c7ebdb75ce7bc74218b506c3182f145df7a4e273a8f3e14550f0fe8653df'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '120.0.5524.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
