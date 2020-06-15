$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/70.0.3721.0/win/Opera_Developer_70.0.3721.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/70.0.3721.0/win/Opera_Developer_70.0.3721.0_Setup_x64.exe'
  checksum       = 'be544d22bc34f00802b9cfa573f7fc78eaf53e3403032a94a8c9e4e32d6e8440'
  checksum64     = '827ad15ef558f183faa0e7005c10cbcaceedace766c45076ef974b6adf1c8603'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '70.0.3721.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
