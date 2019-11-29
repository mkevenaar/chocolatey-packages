$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.1910.54.400/DF1A0802-36A9-4F6D-AF7F-03C812719C0E/J2020.1910.54.400-Offline-x86.exe'
$checksum32     = 'd6ebc1c4a3359832a79ab45c0f7cab0ded845fa2897e63f93b26f51c22efc5e0'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.1910.54.400/DF1A0802-36A9-4F6D-AF7F-03C812719C0E/J2020.1910.54.400-Offline-x64.exe'
$checksum64     = '7bccfd94a99f126fb64601b1781c592e877106f63a9d9413bfd163b203829d31'
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

