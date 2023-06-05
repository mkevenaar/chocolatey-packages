$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/101.0.4822.0/win/Opera_Developer_101.0.4822.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/101.0.4822.0/win/Opera_Developer_101.0.4822.0_Setup_x64.exe'
  checksum       = '6c5df31f0d9baeeac3dbd63e4d08487a3343e598449e769a7446d87a09c297b6'
  checksum64     = '7c2d72f486a194cb87c47016b3665de42b5fda688d2a762f5c19e0a024e21e09'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '101.0.4822.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
