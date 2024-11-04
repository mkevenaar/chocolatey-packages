$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/116.0.5341.0/win/Opera_Developer_116.0.5341.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/116.0.5341.0/win/Opera_Developer_116.0.5341.0_Setup_x64.exe'
  checksum       = '93e38d006410bd96b405cca1a30f9990ff60cda7809d4247f01ff39d031ab134'
  checksum64     = '52952f6b4ca901a5a655c69bb129957b0599c926542382981d625b015874fb0e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '116.0.5341.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
