$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/62.0.3319.0/win/Opera_Developer_62.0.3319.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/62.0.3319.0/win/Opera_Developer_62.0.3319.0_Setup_x64.exe'
  checksum       = '4b89b35f34ad338c7d6d9cefa120495af301c50b17cd44a00ea8169b06e43fe5'
  checksum64     = '12e8e2e775f0c4372189c330751769c384396a64e074fc4768ef22f9c5a91853'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '62.0.3319.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
