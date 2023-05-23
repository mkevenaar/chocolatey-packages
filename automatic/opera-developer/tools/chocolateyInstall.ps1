$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/100.0.4809.0/win/Opera_Developer_100.0.4809.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/100.0.4809.0/win/Opera_Developer_100.0.4809.0_Setup_x64.exe'
  checksum       = 'a323dbada793111c97dffd49510a82a9e9d1a55ff484cf2fd60d25ea212bf6b7'
  checksum64     = '67804285d03b24147a6c412199b454d99307367290b3d6aaad3af8730ad2a973'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '100.0.4809.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
