$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/69.0.3679.0/win/Opera_Developer_69.0.3679.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/69.0.3679.0/win/Opera_Developer_69.0.3679.0_Setup_x64.exe'
  checksum       = 'd54e8b415ae02a0c232374236d6f1742540bdff0f2ba93d75fe4a135e395fbb9'
  checksum64     = '7df43b29d0af55a43c2d82cdf7a68a23886dd87cdf69ea38144f32d072b86380'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '69.0.3679.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
