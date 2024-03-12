$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/110.0.5104.0/win/Opera_Developer_110.0.5104.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/110.0.5104.0/win/Opera_Developer_110.0.5104.0_Setup_x64.exe'
  checksum       = '64ec4ad2e0535b93a2bc9833d0658fedcc35b82b3e50222ade36538ff699c2ba'
  checksum64     = '5a7079fcd9355899517df6375236cd647a207781ccbbd460e9bd2207066e952d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '110.0.5104.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
