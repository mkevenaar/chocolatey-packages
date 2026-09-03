$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/137.0.6010.1/win/Opera_Developer_137.0.6010.1_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/137.0.6010.1/win/Opera_Developer_137.0.6010.1_Setup_x64.exe'
  checksum       = '4766c4ce886f462d4df76d0221abdfd6668a5827b11baf6d860e8bb54adeae27'
  checksum64     = 'fce787622e6195598e5d777578de323143a6b85e01ea31ddc55c47341ee7fbc6'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '137.0.6010.1'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
