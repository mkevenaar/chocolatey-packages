$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2023.vfo.digital/2023.2210.29.400/E48E86BC-C6FC-4202-B67F-58D5D86A0493/J2023.2210.29.400-Offline-x64.exe'
$checksum64     = '26ecd0e2555126dfcce9cf5abcac3fd04132ee87b72bab26e4ce077cd4290b37'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS *'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

