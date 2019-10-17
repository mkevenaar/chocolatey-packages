$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/66.0.3475.0/win/Opera_Developer_66.0.3475.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/66.0.3475.0/win/Opera_Developer_66.0.3475.0_Setup_x64.exe'
  checksum       = '4218530c62c7c2c1355b9627b705dfc9d06767eef359b58b8715e0d8f7ae6dd7'
  checksum64     = '627721b4373f5ee1d2e653b721ae39ca3b8116f8b557ef91cdfc8e5fea6abb52'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '66.0.3475.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
