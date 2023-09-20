$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/103.0.4928.3/win/Opera_beta_103.0.4928.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/103.0.4928.3/win/Opera_beta_103.0.4928.3_Setup_x64.exe'
  checksum       = 'e9958fabc09ac934f61ce50e59b842017b873fd660c44d023bc380a1ca3c93a5'
  checksum64     = '4e76ac4651b95a2f788142b6d2637d2ceabe09f27fde50ee691eae3ed22ee518'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4928.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
