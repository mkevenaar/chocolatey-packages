$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/119.0.5495.0/win/Opera_Developer_119.0.5495.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/119.0.5495.0/win/Opera_Developer_119.0.5495.0_Setup_x64.exe'
  checksum       = 'a9ad053a1f5d8c2005aebdf4f26e2c99bd8fbdb9be66089caae94c0b4a34218b'
  checksum64     = '4dbea6e400365fa5b962fe6835eacdb8211398bc39c14fb60e5f565d893bae6c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '119.0.5495.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
