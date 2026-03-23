$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/130.0.5846.0/win/Opera_Developer_130.0.5846.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/130.0.5846.0/win/Opera_Developer_130.0.5846.0_Setup_x64.exe'
  checksum       = '9a5d11034f08dcf9758364c80e69dd4cae913d7e6afe6ab2f8ac5649e6db0887'
  checksum64     = '7c8358143ef84a53d803437bb898edf9127f403c84afdd459bc8ea45fd97c52e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '130.0.5846.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
