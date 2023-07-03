$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/102.0.4850.0/win/Opera_Developer_102.0.4850.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/102.0.4850.0/win/Opera_Developer_102.0.4850.0_Setup_x64.exe'
  checksum       = '487743c74c42f6cfb2410df5788a5171ac3a63c49ec2cef4fc582dfabc8f5d48'
  checksum64     = 'd2b9ea28712e7f157aa6d63fb82aeabe21e0bc06de5b8d0442aae8518a4599fb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '102.0.4850.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
