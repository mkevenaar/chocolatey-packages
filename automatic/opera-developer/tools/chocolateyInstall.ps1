$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/136.0.5975.0/win/Opera_Developer_136.0.5975.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/136.0.5975.0/win/Opera_Developer_136.0.5975.0_Setup_x64.exe'
  checksum       = '75e91bce0f27acf6db2054dd15c89b495da4a6fd315a8e4702e42893ab2d92dc'
  checksum64     = '536891fc0e68c0dc2abd21658038017547f3cbc8bc41d425f53f9cb48b423947'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '136.0.5975.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
