$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.14/win/Opera_beta_81.0.4196.14_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/81.0.4196.14/win/Opera_beta_81.0.4196.14_Setup_x64.exe'
  checksum       = 'e47ad5f281c5590c5b84e6f1382116cf5a475aec2faa1d514bc09b8f23b68a47'
  checksum64     = '814c8100a404e40370253d573674ec4d07ca53e09b4efc4891cc141bedc03397'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4196.14'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
