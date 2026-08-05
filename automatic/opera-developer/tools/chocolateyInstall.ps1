$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/136.0.5981.0/win/Opera_Developer_136.0.5981.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/136.0.5981.0/win/Opera_Developer_136.0.5981.0_Setup_x64.exe'
  checksum       = '9db14b6413b99be99281814ddad1edd5919e51445ecb786209c310eee2fe43fb'
  checksum64     = 'fae04b68501e55894a566b1c67a53da4ae84468478f2fb04f2865d43d8b01f97'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '136.0.5981.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
