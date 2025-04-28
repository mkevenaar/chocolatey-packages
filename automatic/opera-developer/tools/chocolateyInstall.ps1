$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/120.0.5516.0/win/Opera_Developer_120.0.5516.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/120.0.5516.0/win/Opera_Developer_120.0.5516.0_Setup_x64.exe'
  checksum       = '077ecabf1ddb47c89ece29860710261881d2af0006ce3e12f1b3568b892c2b5f'
  checksum64     = 'c8fe752625c212ad619e3dd0b0b772e04fbe770bb1ba98a99786004f393a1d66'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '120.0.5516.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
