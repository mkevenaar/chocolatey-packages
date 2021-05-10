$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/77.0.4051.0/win/Opera_Developer_77.0.4051.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/77.0.4051.0/win/Opera_Developer_77.0.4051.0_Setup_x64.exe'
  checksum       = '9c8ca5be00250d9dc37e25b19db703d133f97eb579c12c4248b198e9ec67158e'
  checksum64     = 'e19d1caf2092c498226cf39d5aa550eb4a243bf14270452ea11623a537e70abe'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '77.0.4051.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
