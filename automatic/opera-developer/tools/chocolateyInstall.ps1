$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/98.0.4756.0/win/Opera_Developer_98.0.4756.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/98.0.4756.0/win/Opera_Developer_98.0.4756.0_Setup_x64.exe'
  checksum       = 'fc9c829d86e5320d9f5f1f296434463d339be0f393ba6d06ad7a0b0454621cec'
  checksum64     = '34509795f092800de588eb80b506707d0479e5313bae5e07a9b1ba08cdf17640'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '98.0.4756.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
