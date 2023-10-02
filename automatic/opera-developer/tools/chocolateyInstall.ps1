$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/104.0.4941.0/win/Opera_Developer_104.0.4941.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/104.0.4941.0/win/Opera_Developer_104.0.4941.0_Setup_x64.exe'
  checksum       = '0623ffca026239c644aa0df5237db4211d41aba57cd7646d71f8f28289385b14'
  checksum64     = '0360c90f87119ec6c50e32f668cf494d0954ac6fea15ac04fb5ad1671ec569a0'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '104.0.4941.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
