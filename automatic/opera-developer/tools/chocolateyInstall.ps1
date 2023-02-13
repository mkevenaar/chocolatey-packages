$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/97.0.4704.0/win/Opera_Developer_97.0.4704.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/97.0.4704.0/win/Opera_Developer_97.0.4704.0_Setup_x64.exe'
  checksum       = 'bfd9cbbcc9a85a6c7cf51576fe40654d854cdf2a7471a80ca3e0e5033ceb4f00'
  checksum64     = '30a6d5a1da2668fd8e3cd6faaa7ac7188796462141dbfe42e2b4588e5bf96ac3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4704.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
