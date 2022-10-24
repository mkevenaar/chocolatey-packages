$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/93.0.4582.0/win/Opera_Developer_93.0.4582.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/93.0.4582.0/win/Opera_Developer_93.0.4582.0_Setup_x64.exe'
  checksum       = 'f769381349fc3852940911213beae417827f64d6a2049dfc31e349762dcc8a6d'
  checksum64     = '65409abd96452e5259509fd75022e10571ca1b5e618d1ee395bf62d5976d54cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '93.0.4582.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
