$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/134.0.5938.0/win/Opera_Developer_134.0.5938.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/134.0.5938.0/win/Opera_Developer_134.0.5938.0_Setup_x64.exe'
  checksum       = '2b8f3e8b836527faa12474bf23bc6d6f399231800c0b23895462e3a1b54192b6'
  checksum64     = '695f7feab457db1850b06930c059a3f1230f67d137726636871699b5b06f87d9'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '134.0.5938.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
