$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/103.0.4885.0/win/Opera_Developer_103.0.4885.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/103.0.4885.0/win/Opera_Developer_103.0.4885.0_Setup_x64.exe'
  checksum       = '8523a2a9fabc1253f102e3056b3e63181133f278ac7b37321811e744d6070b7b'
  checksum64     = '014a943797cc6b410e96c07b06922b087a9ef1aba40b03d2332c44f89b3d7791'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '103.0.4885.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
