$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/79.0.4114.0/win/Opera_Developer_79.0.4114.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/79.0.4114.0/win/Opera_Developer_79.0.4114.0_Setup_x64.exe'
  checksum       = '20cecaeb6907da7385992245b5482f3e22de278dbe6f7e9a39917c74ffe798a1'
  checksum64     = 'b83de161b5a92b429c4036c14c60b35549b3683122a5bd8b5c9a5077cec93d54'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '79.0.4114.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
