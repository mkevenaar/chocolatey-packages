$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/62.0.3331.16/win/Opera_beta_62.0.3331.16_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/62.0.3331.16/win/Opera_beta_62.0.3331.16_Setup_x64.exe'
  checksum       = '07a1c6052268303e01e83da0f6561a5b31b0c12ca818d26a4b27cfb3ab2d9f2f'
  checksum64     = '4a5b4d1f39654ab10c45e4fea88f19dbbe7e57d4b715707aa8a428792b6cc5cb'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '62.0.3331.16'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
