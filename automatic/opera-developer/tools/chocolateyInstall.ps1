$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/73.0.3820.0/win/Opera_Developer_73.0.3820.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/73.0.3820.0/win/Opera_Developer_73.0.3820.0_Setup_x64.exe'
  checksum       = 'a653f4375ceb14aba2529e45f8fc5b3028cc5b7d405a71a73cc4fbad40d44401'
  checksum64     = '083d151f4dd92ae74df0058fa92c598ed54497976ca039f80a735a7881a6d29a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '73.0.3820.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
