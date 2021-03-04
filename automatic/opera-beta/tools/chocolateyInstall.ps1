$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.35/win/Opera_beta_75.0.3969.35_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/75.0.3969.35/win/Opera_beta_75.0.3969.35_Setup_x64.exe'
  checksum       = '7b8208860c84bab8c75cd39ea1d5f779c2df2628534ea30d6055021e5a3c16bf'
  checksum64     = '28f5e3a520f487bfc65d1f794e3afd8c11d6031dcbcb7c483eee733800f67c50'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3969.35'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
