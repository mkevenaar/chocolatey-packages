$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/75.0.3967.0/win/Opera_Developer_75.0.3967.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/75.0.3967.0/win/Opera_Developer_75.0.3967.0_Setup_x64.exe'
  checksum       = '969c968c4eae3053e81e49b1b98d0a4bc3aafe4f66c4268d3a99a39667688b8c'
  checksum64     = '8c0dc05cf5e830ff0db382d4b1b5fc62fcabd630a2c73bfa0b5a83439db8c41c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3967.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
