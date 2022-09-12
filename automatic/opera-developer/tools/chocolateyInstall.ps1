$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/92.0.4540.0/win/Opera_Developer_92.0.4540.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/92.0.4540.0/win/Opera_Developer_92.0.4540.0_Setup_x64.exe'
  checksum       = 'e56845d4e3fb96c7b24a89e49ce040b31e5f90463dd85e85bb439172955ae33a'
  checksum64     = 'a469d2001de95b4413baf864142dac882b7cabeb3cbc4d6f30121286b80b07f3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '92.0.4540.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
