$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/87.0.4366.0/win/Opera_Developer_87.0.4366.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/87.0.4366.0/win/Opera_Developer_87.0.4366.0_Setup_x64.exe'
  checksum       = 'c88b03edbdfbe2e5b8551613a1a4849cc549f044ae8920e5a50cbb79cfd3cc8b'
  checksum64     = '5cfad73c8964f2df8b8c3e5fab884a71c2dbe83297e739f04efb86f12ba9f853'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '87.0.4366.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
