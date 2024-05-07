$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/111.0.5159.0/win/Opera_Developer_111.0.5159.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/111.0.5159.0/win/Opera_Developer_111.0.5159.0_Setup_x64.exe'
  checksum       = '8abc57221e9be7774d2f30680081a92d0d27a1aa374844dd76d1741b7e1f2eb1'
  checksum64     = 'b7bec3ca293c4da3ba4cdacb276df3722e93924396ade8765eed707b35c69f89'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '111.0.5159.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
