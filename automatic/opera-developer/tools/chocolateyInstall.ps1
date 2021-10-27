$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/82.0.4218.0/win/Opera_Developer_82.0.4218.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/82.0.4218.0/win/Opera_Developer_82.0.4218.0_Setup_x64.exe'
  checksum       = 'a24c8e113fb315643c5f9029d8b6b9e329748bf46656bf6d44225a37e916214c'
  checksum64     = '83619a4a1858c1e0af0e3b1086e0f57edebd82f99760f8f89c123dc0b01198b1'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '82.0.4218.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
