$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/92.0.4555.0/win/Opera_Developer_92.0.4555.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/92.0.4555.0/win/Opera_Developer_92.0.4555.0_Setup_x64.exe'
  checksum       = '891abcc1dfd67cb4aaebea2a14dccd2ad58443c9284f641871ac872ecbdc3de8'
  checksum64     = 'a64a84d155fecb2047a13dd231b1c51977518b6a41321bb0b5dc06a14dc5d8aa'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4555.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
