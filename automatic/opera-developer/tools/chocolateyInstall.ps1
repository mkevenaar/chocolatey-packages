$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/62.0.3323.0/win/Opera_Developer_62.0.3323.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/62.0.3323.0/win/Opera_Developer_62.0.3323.0_Setup_x64.exe'
  checksum       = '5d1250d3add97ec9dec9415be823d68a071acc4f6d65eb73b6f535def46c965c'
  checksum64     = 'd352b73710f61e4ba673c4370924a79e32d850644abf0c37d552bdaea9d0a3d3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '62.0.3323.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
