$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2202.38.400/64B90A11-AE0E-45FB-B94B-EFE626B7C9EC/J2022.2202.38.400-Offline-x86.exe'
$checksum32     = 'b4e363c164b6535c8e0b2c1d5adfa123f37507945f75583707789a47b5fe5e32'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2202.38.400/64B90A11-AE0E-45FB-B94B-EFE626B7C9EC/J2022.2202.38.400-Offline-x64.exe'
$checksum64     = '9b9f21b072f52cc59dabe3e3d96663810055bd22769d8a30c686d907c4ca83e4'
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

