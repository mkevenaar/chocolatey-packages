$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.3/win/Opera_beta_91.0.4516.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/91.0.4516.3/win/Opera_beta_91.0.4516.3_Setup_x64.exe'
  checksum       = '263fc4ef48fb3ba073a5de2ac75fc132c0704f75df0f8b8983ee45293d2cc916'
  checksum64     = '492333342921c34fc298f33402d7282e58204c729f4273e62c2d5b431ec17595'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4516.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
