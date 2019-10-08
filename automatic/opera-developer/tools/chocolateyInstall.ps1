$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3466.0/win/Opera_Developer_65.0.3466.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3466.0/win/Opera_Developer_65.0.3466.0_Setup_x64.exe'
  checksum       = 'd7ed9acf820891d10a0f34b0ae1684006572ea0215286b5ddf2a54d0ff5695fc'
  checksum64     = 'b045cbe361eedc2fac6034110fd46562459e1ac89e54b00410ce90746e0471cd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3466.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
