$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/84.0.4274.0/win/Opera_Developer_84.0.4274.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/84.0.4274.0/win/Opera_Developer_84.0.4274.0_Setup_x64.exe'
  checksum       = 'b130feb44f3b0a86df203092a6a98452d8d8d4f8da4865384faa42bc9b0c0456'
  checksum64     = '50873f388113262641f4048651d97e3f94bbf17ea287d2e4638244b2f8471f8a'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '84.0.4274.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
