$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/118.0.5428.0/win/Opera_Developer_118.0.5428.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/118.0.5428.0/win/Opera_Developer_118.0.5428.0_Setup_x64.exe'
  checksum       = 'e9c91afeb367204058880f78ff875e72b1b704d991ed6923264e402e2849b9a5'
  checksum64     = '384c2ca8ab686e54bf783aac4b8fbeddcc7faefa35265165ff9b4be4487287b9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '118.0.5428.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
