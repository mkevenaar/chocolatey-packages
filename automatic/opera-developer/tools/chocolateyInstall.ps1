$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/137.0.6015.0/win/Opera_Developer_137.0.6015.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/137.0.6015.0/win/Opera_Developer_137.0.6015.0_Setup_x64.exe'
  checksum       = 'dce1682cbfa77a5d2961e5ef7a7a1095dea6a2998a81b3481f8237ef58f62d1d'
  checksum64     = 'f97732c443b69c41bed38c654ba6d3e3164e997b14cf6ea013299bc95ba13ed1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '137.0.6015.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
