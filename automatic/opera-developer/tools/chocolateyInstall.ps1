$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/68.0.3590.0/win/Opera_Developer_68.0.3590.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/68.0.3590.0/win/Opera_Developer_68.0.3590.0_Setup_x64.exe'
  checksum       = '73321c3038645ead5cdd8737dfb9d7126bd2c4dd603c0b83b073cc882e3ac46c'
  checksum64     = '12d2550f204e2ea6b0e412a940cf4f1a55fda2c4d06e0d509985098476f5585d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '68.0.3590.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
