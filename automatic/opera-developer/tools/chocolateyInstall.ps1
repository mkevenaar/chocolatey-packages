$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/133.0.5917.0/win/Opera_Developer_133.0.5917.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/133.0.5917.0/win/Opera_Developer_133.0.5917.0_Setup_x64.exe'
  checksum       = '638f47c88c263032a34b4f71727424e31f3fdbe35a957df379ff747daf9db9cd'
  checksum64     = '4906ecacf2b7204a7c03d9a7e52d63cc5543da3573b8c9905268a4d8417520fd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '133.0.5917.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
