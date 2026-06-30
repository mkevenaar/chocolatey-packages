$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/134.0.5945.0/win/Opera_Developer_134.0.5945.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/134.0.5945.0/win/Opera_Developer_134.0.5945.0_Setup_x64.exe'
  checksum       = 'f5435e4c9bb808e56f778e92f6a915b177f169df9521acb31fda665d4d094fce'
  checksum64     = '11beadc0c7fd81a10e3f770b9efc716ec41aa9b0a91243af5cb468159ea7f6d9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '134.0.5945.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
