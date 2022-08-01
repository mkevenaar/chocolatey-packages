$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/91.0.4498.0/win/Opera_Developer_91.0.4498.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/91.0.4498.0/win/Opera_Developer_91.0.4498.0_Setup_x64.exe'
  checksum       = '84bbe3688558f0025dba7f48aa061e22aa7d44ae8350f3e101a7609a5cd62ec1'
  checksum64     = 'c62030a397fee3e5b08a65fc5a28543d6f7fbeb1c477f599a02f57e5e931196d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4498.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
