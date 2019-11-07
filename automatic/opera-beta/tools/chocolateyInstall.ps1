$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.32/win/Opera_beta_65.0.3467.32_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/65.0.3467.32/win/Opera_beta_65.0.3467.32_Setup_x64.exe'
  checksum       = '545fd32cb3c8676c939d24ddcc20a162e621033c5839aa9f7302700454e93d5f'
  checksum64     = '9825f57477d8f7df76e50a213d34a648ec419b31be4bab469b3f5a565d885e01'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '65.0.3467.32'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
