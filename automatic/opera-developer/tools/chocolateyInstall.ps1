$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/116.0.5362.0/win/Opera_Developer_116.0.5362.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/116.0.5362.0/win/Opera_Developer_116.0.5362.0_Setup_x64.exe'
  checksum       = '7ebd6469ba3fcc3982d7d00620f643910940effed8e64346a9bac90efc86615f'
  checksum64     = 'c67f4bee0b46d245befc286c3d36aec052c8ef6095d76014c9e7d19ee173c06e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '116.0.5362.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
