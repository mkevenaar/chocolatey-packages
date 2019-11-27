$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3515.2/win/Opera_Developer_66.0.3515.2_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3515.2/win/Opera_Developer_66.0.3515.2_Setup_x64.exe'
  checksum       = '40e1271228dd647700be3b8a57e431f63ae779840f2422f62fde6a25868dbac4'
  checksum64     = '58ac05bcec94d798a1aa8e90926f801634dc06683d6ff292a425b1bce5c632be'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3515.2'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
