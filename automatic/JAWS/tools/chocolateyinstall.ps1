$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2011.16.400/21F14494-6E65-4803-AC0A-5E8C18AE016B/J2021.2011.16.400-Offline-x86.exe'
$checksum32     = '3f2f8c6ec01f91beac67336cc78741ad41d3e9ed58afa26d6c8427801302897b'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2011.16.400/21F14494-6E65-4803-AC0A-5E8C18AE016B/J2021.2011.16.400-Offline-x64.exe'
$checksum64     = 'cba8623e04a948f6d4b498492e222210d6d1e83980f15e74eb4a0f1c1d9d7f2e'
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

