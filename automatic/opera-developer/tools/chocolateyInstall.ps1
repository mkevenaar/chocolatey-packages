$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/115.0.5305.0/win/Opera_Developer_115.0.5305.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/115.0.5305.0/win/Opera_Developer_115.0.5305.0_Setup_x64.exe'
  checksum       = '1904b807fede61bf9baa50fa662e11f2e3245927b97301d6bf98ec7018367ccc'
  checksum64     = 'fa7ef65a40fd6c6e7c1743ac63cadd113e925ff54be070a33150ab4f57d2512b'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '115.0.5305.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
