$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/81.0.4189.0/win/Opera_Developer_81.0.4189.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/81.0.4189.0/win/Opera_Developer_81.0.4189.0_Setup_x64.exe'
  checksum       = '5068a326982a0685590c4e9c3f9dcb765af3abb9ddcadc07852394cc0294a829'
  checksum64     = '8b438123099981d5f755501cd6bf394c2603a7aa606e649f84a27f7ffb3041b3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '81.0.4189.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
