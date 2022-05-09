$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/89.0.4415.0/win/Opera_Developer_89.0.4415.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/89.0.4415.0/win/Opera_Developer_89.0.4415.0_Setup_x64.exe'
  checksum       = 'a43c471085444ccbcc02cb52433c7164867b672a0a53adcd593e70a548fdc87f'
  checksum64     = 'da30cebc5214ceace432bd968281d77e54e9dba3dc975f1d9e1357dfb2a283bc'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4415.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
