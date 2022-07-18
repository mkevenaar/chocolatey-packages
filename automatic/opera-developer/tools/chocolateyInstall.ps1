$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/91.0.4484.0/win/Opera_Developer_91.0.4484.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/91.0.4484.0/win/Opera_Developer_91.0.4484.0_Setup_x64.exe'
  checksum       = '3d27d1d1f1feace580b075545be433385874a1211c61a5afe62b4af7800c351a'
  checksum64     = '6c20c48d1d4168a99ae3b12cb3c8ed0f55748c5042ce06ec1b78c85abc49af07'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '91.0.4484.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
