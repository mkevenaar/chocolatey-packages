$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/137.0.6029.0/win/Opera_Developer_137.0.6029.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/137.0.6029.0/win/Opera_Developer_137.0.6029.0_Setup_x64.exe'
  checksum       = 'c05bf8a7e54a19c5d3129a112951d7e57127e432965713905fc6347e722d13cb'
  checksum64     = '3e90a2727d6c1638f4612a73a6bfee519ac6bf8629019125dad3e0ee74ee408d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '137.0.6029.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
