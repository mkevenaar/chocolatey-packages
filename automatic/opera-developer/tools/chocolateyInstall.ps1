$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/87.0.4382.0/win/Opera_Developer_87.0.4382.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/87.0.4382.0/win/Opera_Developer_87.0.4382.0_Setup_x64.exe'
  checksum       = 'a6ddb2778a2969a28bddab741c47151f3d5dcada2f8271eddff77cc0cbb630d2'
  checksum64     = 'ded40d0a3cf3f1712a9729e4a129322b9e5549a4ce6e408db35cbf4c19b104f7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '87.0.4382.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
