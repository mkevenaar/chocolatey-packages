$ErrorActionPreference = 'Stop';

$url32          = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
$checksum32     = '7638a89cbd0b82fba383e44ba5fabc554c3ac0285d0ce3200d2b45e0dc2caaef'
$checksumType32 = 'sha256'
$url64          = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'
$checksum64     = 'ea2a026d7babbc5387b59c810c222dac04442779eb71fd4fd51154d0da2a6bcb'
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
