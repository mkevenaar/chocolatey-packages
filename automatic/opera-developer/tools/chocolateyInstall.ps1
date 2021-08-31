$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/80.0.4162.0/win/Opera_Developer_80.0.4162.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/80.0.4162.0/win/Opera_Developer_80.0.4162.0_Setup_x64.exe'
  checksum       = 'e7a77f7222edd1f92eafc0d00423ece06f7aa7c484b46197362ab2a6425ae485'
  checksum64     = '7ca913e23596229140c5e72ddbb28b21762d969d5c520bdb79614eee1443b47e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '80.0.4162.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
