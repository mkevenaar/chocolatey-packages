$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/82.0.4203.0/win/Opera_Developer_82.0.4203.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/82.0.4203.0/win/Opera_Developer_82.0.4203.0_Setup_x64.exe'
  checksum       = '44af120fbd7ab89b323b6482dee854ee511fd2d9f9e7b0654de6ed8cea099cac'
  checksum64     = '7eeb4c8effc6c75e59eccfde013a1126f0e881efc1634a6b3d35176d3881c60b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4203.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
