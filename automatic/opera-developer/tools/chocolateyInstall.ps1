$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/111.0.5167.0/win/Opera_Developer_111.0.5167.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/111.0.5167.0/win/Opera_Developer_111.0.5167.0_Setup_x64.exe'
  checksum       = 'baed262f8c6154aa44129efa79143ab4e9d77d1302094c40881fa53976a9a347'
  checksum64     = '52c4164fbdddb4c695e6df9903f2e8659ac0d31e6807f51b7431567b60abca9f'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '111.0.5167.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
