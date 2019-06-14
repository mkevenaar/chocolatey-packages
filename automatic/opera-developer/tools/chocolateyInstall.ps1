$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/63.0.3349.0/win/Opera_Developer_63.0.3349.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/63.0.3349.0/win/Opera_Developer_63.0.3349.0_Setup_x64.exe'
  checksum       = '251bc89b9f605d3cde0897aa3d9828aaebd87f54236813a0dcc4c4078a897491'
  checksum64     = '702f8b88663867930bca245b332644cc2af45ea97e8ee65c23cf0896257c7083'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '63.0.3349.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
