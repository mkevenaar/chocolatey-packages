$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/78.0.4079.0/win/Opera_Developer_78.0.4079.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/78.0.4079.0/win/Opera_Developer_78.0.4079.0_Setup_x64.exe'
  checksum       = '22132f85e7e5403fd26cb2bef30d71413b67cafab259c0200e26ccf314089c43'
  checksum64     = '6fdf6e3b7030c89903b756e1d0455b641f4ed4766af414e172203106f903bc20'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4079.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
