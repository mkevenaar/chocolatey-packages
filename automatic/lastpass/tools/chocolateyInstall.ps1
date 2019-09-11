$ErrorActionPreference = 'Stop';

$url32          = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
$checksum32     = '9354e7d164aa838af0e4835a8f1f7bc01ba591ccf43739fb0625b5ad43629882'
$checksumType32 = 'sha256'
$url64          = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'
$checksum64     = '9427dcc285bf574c7aab03e998e7c2062f0a3e62619048062bf956ebcf1b48fa'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = 'lastpass'
  installerType  = 'exe'
  url            = $url32
  url64          = $url64
  checksum       = $checksum32
  checksum64     = $checksum64
  checksumType   = $checksumType32
  checksumType64 = $checksumType64
  silentArgs     = '-si --userinstallie --userinstallff --userinstallchrome'
  validExitCodes = @(0)
}
 
Install-ChocolateyPackage @packageArgs
