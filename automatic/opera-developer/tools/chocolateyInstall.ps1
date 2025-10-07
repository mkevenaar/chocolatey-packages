$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/124.0.5678.0/win/Opera_Developer_124.0.5678.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/124.0.5678.0/win/Opera_Developer_124.0.5678.0_Setup_x64.exe'
  checksum       = '2d096c20bec417fbf39c439b9a52b5252c09192f4e54f4fbd3a1acd8f5c5be17'
  checksum64     = '40ec3da02f94cba5c83472d568ea52ef6021f25d98fbcb8e3e0e606cb94edb56'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '124.0.5678.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
