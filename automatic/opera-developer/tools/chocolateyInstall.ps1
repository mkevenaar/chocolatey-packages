$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/117.0.5369.0/win/Opera_Developer_117.0.5369.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/117.0.5369.0/win/Opera_Developer_117.0.5369.0_Setup_x64.exe'
  checksum       = 'b52d5c4103310d6bebf131ef1a3cf268a5c516af6d0ca98b730f31ff7fadeec6'
  checksum64     = '2769b9f1944b6c20dd3c27f83555fa4a5724840beedc284f7e3563cd3b86290f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '117.0.5369.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
