$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3779.0/win/Opera_Developer_72.0.3779.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3779.0/win/Opera_Developer_72.0.3779.0_Setup_x64.exe'
  checksum       = '5a3ff29dcc52a875a894bd4e1c67be47c5e3fddeee750ebb66ddd81b4029e938'
  checksum64     = '187692f36887dee95a4b2033198c51f12022f6486a5f333a3f86bb33af760db4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3779.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
