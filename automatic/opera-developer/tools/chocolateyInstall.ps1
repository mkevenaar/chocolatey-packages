$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/85.0.4331.0/win/Opera_Developer_85.0.4331.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/85.0.4331.0/win/Opera_Developer_85.0.4331.0_Setup_x64.exe'
  checksum       = 'ee45275964bdac1ac2280846abdae79bc1aa1d993427df7375728d56d178fc3d'
  checksum64     = '0a150afa90e1fb0ffa1608ccc1e62bf67744524bc1ecc0d517d1243cf76905f1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '85.0.4331.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
