$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/136.0.5988.0/win/Opera_Developer_136.0.5988.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/136.0.5988.0/win/Opera_Developer_136.0.5988.0_Setup_x64.exe'
  checksum       = '7329ad23f4757b053ef0ce07b7ea6359ca510188adb995bda97958396bdc74cc'
  checksum64     = 'fa9246f514658fcecc4c1ac59beaa725899eead9a101bcd1da80724e79e430cd'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '136.0.5988.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
