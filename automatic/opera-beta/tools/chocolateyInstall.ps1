$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.37/win/Opera_beta_89.0.4447.37_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-beta/89.0.4447.37/win/Opera_beta_89.0.4447.37_Setup_x64.exe'
  checksum       = '70191a884b087fb4d2db7af07b9f77de45de7f07358c63c3a34d85135deb0e9f'
  checksum64     = '1da62274c9a925d93e9a34d541274291254705ea35e401ac29a5fc638ea1e87e'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '89.0.4447.37'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
