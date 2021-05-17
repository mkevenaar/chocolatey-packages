$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/78.0.4058.0/win/Opera_Developer_78.0.4058.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/78.0.4058.0/win/Opera_Developer_78.0.4058.0_Setup_x64.exe'
  checksum       = 'b82e52467631bb5250849643e1a9da7fe852f0203cdbd0143ca0504d2d8ff8af'
  checksum64     = '47b5a6c1bc30a4ce1c97fffa92ac90e61dae5c94dd64b752b5cd806de4c20e9c'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '78.0.4058.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
