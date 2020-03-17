$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.2003.13.400/312E174D-9825-412C-8AC2-C1BCECEF3D7D/J2020.2003.13.400-Offline-x86.exe'
$checksum32     = 'b319572f04d0d3033fcc3cd0081a969c7d6c21458c3e08a7a10a4d179fccf179'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.2003.13.400/312E174D-9825-412C-8AC2-C1BCECEF3D7D/J2020.2003.13.400-Offline-x64.exe'
$checksum64     = 'c057745279da70a288c201d3a23cb6fbded6fc723fabb88e87be1fc3494e0635'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS 2020*'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

