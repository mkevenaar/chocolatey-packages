$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/100.0.4790.0/win/Opera_Developer_100.0.4790.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/100.0.4790.0/win/Opera_Developer_100.0.4790.0_Setup_x64.exe'
  checksum       = '6f305ccabc632ab1c946f02a4487e35f468bb80e4f7afa44ddf7622d707f9fc4'
  checksum64     = '098406feaeb5ae21f312d6cf2d791dca2d2de7c1f012395a27d37d4117251ea4'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4790.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
