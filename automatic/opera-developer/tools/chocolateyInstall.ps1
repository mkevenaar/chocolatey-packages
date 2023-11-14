$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/106.0.4985.0/win/Opera_Developer_106.0.4985.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/106.0.4985.0/win/Opera_Developer_106.0.4985.0_Setup_x64.exe'
  checksum       = '5e106b88dd5dba966646444da3938dd5b59989e2d5285ab6d7d6d3d74e2c50ca'
  checksum64     = 'f32496953b6e9ecd7e25938f2274b51a7f8fd55c8068ff8f76b51c0eb55e5d79'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '106.0.4985.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
