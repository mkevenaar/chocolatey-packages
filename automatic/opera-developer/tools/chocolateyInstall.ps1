$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/118.0.5425.0/win/Opera_Developer_118.0.5425.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/118.0.5425.0/win/Opera_Developer_118.0.5425.0_Setup_x64.exe'
  checksum       = 'c87d390d87fa9275bbaca1d75bcc5fb62599d3dfece3afcf97e4278ea9448aee'
  checksum64     = '3e956faa1c0625e6c6e4ea7c2d4d0335a2d5605478bf20b21a88adb4f02735ed'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '118.0.5425.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
