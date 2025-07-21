$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/121.0.5600.0/win/Opera_Developer_121.0.5600.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/121.0.5600.0/win/Opera_Developer_121.0.5600.0_Setup_x64.exe'
  checksum       = 'c093f24a79c1e95e8b324c07f21f27a8bc377b6b2e1834c4224d1e9f49081729'
  checksum64     = '9a53c5236997d1924ac14e66ed6ff6cc1f071ad4dae90db57d38e4436363371f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '121.0.5600.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
