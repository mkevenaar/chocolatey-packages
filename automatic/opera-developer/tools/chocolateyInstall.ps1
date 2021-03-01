$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.3981.0/win/Opera_Developer_76.0.3981.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.3981.0/win/Opera_Developer_76.0.3981.0_Setup_x64.exe'
  checksum       = '269ff5c76d410b34e3d4470cc73834bffef3ae96489646c1f51f6108ce27668e'
  checksum64     = 'c065f3ffdc5968e0b98e191aa5cbbff4b8c6ce530ed6f4acc29025e95bbc765e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.3981.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
