$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/102.0.4864.0/win/Opera_Developer_102.0.4864.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/102.0.4864.0/win/Opera_Developer_102.0.4864.0_Setup_x64.exe'
  checksum       = '4faf4ca99c67cd5aff0ac7b93c16b8ec53931448e441c453967c973189ff9dfd'
  checksum64     = '604e4abcb8b29a2e8f3d7fe28ba5eafcaa7499efc3bafca07c6c4e1fb66efbb1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4864.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
