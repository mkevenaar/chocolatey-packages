$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/92.0.4561.0/win/Opera_Developer_92.0.4561.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/92.0.4561.0/win/Opera_Developer_92.0.4561.0_Setup_x64.exe'
  checksum       = 'c0c8f139b3c454336892fcfe394109b5151b5b56282f8e7efe18bfbfbdcb6e6f'
  checksum64     = 'f831b85b75a220f3d8d795319916165180b74648f1787e32f209738fdc241d8c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4561.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
