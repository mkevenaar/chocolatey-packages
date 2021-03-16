$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/76.0.3995.0/win/Opera_Developer_76.0.3995.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/76.0.3995.0/win/Opera_Developer_76.0.3995.0_Setup_x64.exe'
  checksum       = '7a97f6b0cc6792877f87efeb79645022fd3deff1c69b16c499243f58e20c9ea1'
  checksum64     = 'd3fd4c135df94405b7cb84e986d45bbe6e060426745e9451ffcdb359fb26f1d0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '76.0.3995.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
