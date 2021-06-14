$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/78.0.4086.0/win/Opera_Developer_78.0.4086.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/78.0.4086.0/win/Opera_Developer_78.0.4086.0_Setup_x64.exe'
  checksum       = '801c2bc409923488fb5b716e741ea9e97de4bf11e78c695c6c11cd142e15d978'
  checksum64     = '9de5a80e8225809365edef7e2802990bc4e0622d76d73e60b59369b6b1975bc0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4086.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
