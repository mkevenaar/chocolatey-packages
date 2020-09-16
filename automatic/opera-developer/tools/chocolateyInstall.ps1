$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/72.0.3814.0/win/Opera_Developer_72.0.3814.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/72.0.3814.0/win/Opera_Developer_72.0.3814.0_Setup_x64.exe'
  checksum       = '5a6d33cd681e7bafbf97c26b0918b34f62d2dfc554921755c3ba345719a96c9b'
  checksum64     = 'fdff8005684034f77a277e2c0e626c004d62907f15b7086e110b38c53d7ede37'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '72.0.3814.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
