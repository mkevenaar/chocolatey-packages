$ErrorActionPreference = 'Stop';

$url32          = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
$checksum32     = '13a55227a3313151c32eda6b4c2a1e6facdd23a5d9e0e4664b5b2ea3b721b4bb'
$checksumType32 = 'sha256'
$url64          = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'
$checksum64     = 'f20afa9f0973df8a3044257feb246f3bdcc8c2faadf2ba9c9952bd27c9527cc8'
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

Install-ChocolateyPackage @packageArgs
