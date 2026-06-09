$ErrorActionPreference = 'Stop'
$toolsPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
. "$toolsPath\helpers.ps1"

$pp = Get-PackageParameters

$parameters += if ($pp.NoDesktopShortcut)     { " /desktopshortcut 0"; Write-Host "Desktop shortcut won't be created" }
$parameters += if ($pp.NoTaskbarShortcut)     { " /pintotaskbar 0"; Write-Host "Opera won't be pinned to taskbar" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://get.geo.opera.com/pub/opera-developer/133.0.5924.0/win/Opera_Developer_133.0.5924.0_Setup.exe'
  url64          = 'https://get.geo.opera.com/pub/opera-developer/133.0.5924.0/win/Opera_Developer_133.0.5924.0_Setup_x64.exe'
  checksum       = '056ee94d4cc42454005f6c1cb636bb1943fc63f1918a1242bca024fc236246ac'
  checksum64     = 'faf42a09ae69fa860348962796b19ef7c6a855866a48a004698599481b54bc07'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = '/install /silent /launchopera 0 /setdefaultbrowser 0' + $parameters
  validExitCodes = @(0)
}

$version = '133.0.5924.0'
if (!$Env:ChocolateyForce -and (IsVersionAlreadyInstalled $version)) {
  Write-Output "Opera $version is already installed. Skipping download and installation."
} else {
  Install-ChocolateyPackage @packageArgs
}
