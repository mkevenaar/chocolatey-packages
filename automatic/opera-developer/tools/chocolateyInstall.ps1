$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/75.0.3925.0/win/Opera_Developer_75.0.3925.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/75.0.3925.0/win/Opera_Developer_75.0.3925.0_Setup_x64.exe'
  checksum       = 'ab2e3d1d5556f9eb85e8e851cb2b2050d40885af5938fb0877b1e194e76bc96a'
  checksum64     = 'b3bedf3725e194dd5ae771f6cb879c2e9409b90f7e6820f08cdec637d02dad01'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '75.0.3925.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
