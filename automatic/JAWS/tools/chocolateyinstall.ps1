$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2110.36.400/5BB39DAB-6F82-4139-86C3-9B5488CE29BE/J2022.2110.36.400-Offline-x86.exe'
$checksum32     = '6b7be1c52c915a1475801b42ffd19eea341b6d8c74760b6287dff5da400fc605'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2110.36.400/5BB39DAB-6F82-4139-86C3-9B5488CE29BE/J2022.2110.36.400-Offline-x64.exe'
$checksum64     = '25562a2bba824d90165dba97bc8691b7f13d43f41518fea25b34464f697e4753'
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

