$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/118.0.5446.0/win/Opera_Developer_118.0.5446.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/118.0.5446.0/win/Opera_Developer_118.0.5446.0_Setup_x64.exe'
  checksum       = '7efeae95c2bcd9e2a397650250b8d00dabb2b0d79f445c31f791a0877dad2f3b'
  checksum64     = 'c2a93bae32b4be366907677f2d0ccf12e26b2e97edd936ed857b4a175537454a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '118.0.5446.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
