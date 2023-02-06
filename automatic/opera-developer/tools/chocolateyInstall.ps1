$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/97.0.4697.0/win/Opera_Developer_97.0.4697.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/97.0.4697.0/win/Opera_Developer_97.0.4697.0_Setup_x64.exe'
  checksum       = '702fb921f3eb5ba26aed3a50c3f3ecb1635fa27ad7e74dc918930d3bef661ddd'
  checksum64     = '4d60203a80b46a854f95a82525f9df22650d477a44fa3ffb940e577ec33da1cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '97.0.4697.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
