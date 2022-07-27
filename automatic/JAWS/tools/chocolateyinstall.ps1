$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2207.25.400/2ACCEDFA-0210-472F-9953-AE54DF593427/J2022.2207.25.400-Offline-x86.exe'
$checksum32     = '2b9021ef9f082b2ef547038ab45d7062f749e73128b8d32b834836bd09093fb3'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2207.25.400/2ACCEDFA-0210-472F-9953-AE54DF593427/J2022.2207.25.400-Offline-x64.exe'
$checksum64     = 'd8848f7fe098ce75822dffa83ba7ee97d6743a6617f8363483e2b39910c4c81e'
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

