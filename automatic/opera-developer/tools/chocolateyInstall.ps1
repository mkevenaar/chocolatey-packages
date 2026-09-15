$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/137.0.6022.0/win/Opera_Developer_137.0.6022.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/137.0.6022.0/win/Opera_Developer_137.0.6022.0_Setup_x64.exe'
  checksum       = 'dfd56fbd30dd4e34636b5ddb682be7a1b3f9eb117096c21494388ef5e1777cde'
  checksum64     = '96b8fd78acd081940b81012f490145426aeee84a46cb823392a5a6c861a2ef11'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '137.0.6022.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
