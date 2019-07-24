$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/64.0.3388.0/win/Opera_Developer_64.0.3388.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/64.0.3388.0/win/Opera_Developer_64.0.3388.0_Setup_x64.exe'
  checksum       = '2db24684743a67a339ac6081bebc2a28e1afa32166f6cbf21e8fa0c321d8643a'
  checksum64     = '81452e0bca87e204f65d574a9ebb2f539b004eb809515e826feae932e22cbab3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '64.0.3388.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
