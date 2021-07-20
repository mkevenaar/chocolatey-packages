$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2021.vfo.digital/2021.2107.12.400/CCCC3B93-1C9A-4AD9-B616-923E91ED7651/J2021.2107.12.400-Offline-x86.exe'
$checksum32     = 'b7af3e813e68a1a835d6b43f696883d26e8cb1e31839d705cccf87bad8187fa8'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2021.vfo.digital/2021.2107.12.400/CCCC3B93-1C9A-4AD9-B616-923E91ED7651/J2021.2107.12.400-Offline-x64.exe'
$checksum64     = 'abb9b0dc997351ccba45c9308c8dfa0dd51a4b5cee122214f3e8e72dc27b8b16'
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

