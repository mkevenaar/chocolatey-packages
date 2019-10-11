$ErrorActionPreference = 'Stop';

$url32          = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
$checksum32     = '59bc00a976b07bd02013fc9a5b4ab6892e57cfa00db822c1bb61185a6516b7b8'
$checksumType32 = 'sha256'
$url64          = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'
$checksum64     = '3b436b6509aa8678c2843b3e1a2f4194c7a7dd7a1a3d1c010d81f5424bf95cf5'
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
