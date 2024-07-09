$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/113.0.5222.0/win/Opera_Developer_113.0.5222.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/113.0.5222.0/win/Opera_Developer_113.0.5222.0_Setup_x64.exe'
  checksum       = '2252ebcd7b6ecf1de1f5ecce5bb501b0d0bf5ffc55a81260ec49b0a35d1f85ab'
  checksum64     = '195876e66c4e7506cb21aa0fbbf60f5244e66e9469463beb08359f8ad5352bb7'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '113.0.5222.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
