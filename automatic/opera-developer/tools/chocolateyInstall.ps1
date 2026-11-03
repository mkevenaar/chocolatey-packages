$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/140.0.6072.0/win/Opera_Developer_140.0.6072.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/140.0.6072.0/win/Opera_Developer_140.0.6072.0_Setup_x64.exe'
  checksum       = '1be02c15e46b33dce3520ca19dee71b9f18c18b8dd17aaa437b066381848068c'
  checksum64     = 'ea0da2eb13e6de4d4dd0f1f046eed4bc05308771a857d0975a30e4e68da31373'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '140.0.6072.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
