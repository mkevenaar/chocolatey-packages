$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2022.vfo.digital/2022.2207.25.400/2ACCEDFA-0210-472F-9953-AE54DF593427/J2022.2207.25.400-Offline-x64.exe'
$checksum64     = 'd8848f7fe098ce75822dffa83ba7ee97d6743a6617f8363483e2b39910c4c81e'
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

