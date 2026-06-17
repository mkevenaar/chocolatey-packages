$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/133.0.5931.0/win/Opera_Developer_133.0.5931.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/133.0.5931.0/win/Opera_Developer_133.0.5931.0_Setup_x64.exe'
  checksum       = '3d25ae21ef129ff812d25db781403a7a4d46c3ff9a5a70c2743bf3dc633e44ad'
  checksum64     = '24870de81f8f76ced21d8d3087e7f76350d736665da36f9878a445ae12290aaf'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '133.0.5931.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
