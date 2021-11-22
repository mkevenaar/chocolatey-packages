$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2110.60.400/5AF06B29-09AE-4E25-8F7F-7778A2FC22B9/J2022.2110.60.400-Offline-x86.exe'
$checksum32     = 'e24d877030a70ad95a12ed68cf13704d38a927445c624a7b03f50079e3a0fee0'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2110.60.400/5AF06B29-09AE-4E25-8F7F-7778A2FC22B9/J2022.2110.60.400-Offline-x64.exe'
$checksum64     = '09ab25e419d40db9b32c3e3447485637492de1550f0fe882529fcd1481cd2da2'
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

