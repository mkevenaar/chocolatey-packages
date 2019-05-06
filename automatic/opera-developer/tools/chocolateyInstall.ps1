$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/61.0.3298.3/win/Opera_Developer_61.0.3298.3_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/61.0.3298.3/win/Opera_Developer_61.0.3298.3_Setup_x64.exe'
  checksum       = '8c5c541c04ce2929fcc459a3038e630503947504e089f3784d8af02b4856b15a'
  checksum64     = '384769d2714f54cc08d4268a03e04ca9e142cc8598d479ba4de59038e260ccb9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '61.0.3298.3'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
