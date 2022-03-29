$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/87.0.4374.0/win/Opera_Developer_87.0.4374.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/87.0.4374.0/win/Opera_Developer_87.0.4374.0_Setup_x64.exe'
  checksum       = 'cbd79f87c7810217d335f657d46d9661c98d780aaca3003f4e13200cd28cd3a3'
  checksum64     = '43fc4758276dd4e333ed75cc2364278999ac9fc5dfd930abbcf17d7ad800f597'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '87.0.4374.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
