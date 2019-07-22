$ErrorActionPreference = 'Stop';

$url32          = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
$checksum32     = '10ae04d5facd3fb92beae3a40dcd60e63efed6154268b0a8733ce1961ecc96b7'
$checksumType32 = 'sha256'
$url64          = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'
$checksum64     = '4f66a5c28b58811a74ed828f536c3e2d4953c0da80fdbd8627575d22a7424f68'
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
