$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/103.0.4906.0/win/Opera_Developer_103.0.4906.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/103.0.4906.0/win/Opera_Developer_103.0.4906.0_Setup_x64.exe'
  checksum       = '1037bdb52ffcd129640e0554273e7e4a7d32cf67aba5bef211f83d19580cc76b'
  checksum64     = 'a2db83e56e85996b54df550d5bd5646427df7dcd22acd8a9e174e688280a48ff'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4906.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
