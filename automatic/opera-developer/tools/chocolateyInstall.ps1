$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/81.0.4183.0/win/Opera_Developer_81.0.4183.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/81.0.4183.0/win/Opera_Developer_81.0.4183.0_Setup_x64.exe'
  checksum       = '5ef8505229d6a2469996e6a78f74721b90dd24f57901e597ad64e9e392b7b691'
  checksum64     = '22d54ade525decd30cd6e6ff006b4071cd744dbb3b1c6807e8ce4c6e05582e1f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4183.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
