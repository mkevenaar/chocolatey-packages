$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/65.0.3437.0/win/Opera_Developer_65.0.3437.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/65.0.3437.0/win/Opera_Developer_65.0.3437.0_Setup_x64.exe'
  checksum       = '63b883ced3cab206c8de935668355bc5a462bb55160dcb6b68e4f8a1ce11633f'
  checksum64     = '8c7a72c6b81a600938389e2a55ef56e4ae41bf71c5c6cc8fc2ee3c1ea11fb3df'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3437.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
