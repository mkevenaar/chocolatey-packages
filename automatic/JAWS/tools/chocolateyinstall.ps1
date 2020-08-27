$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'http://jaws2020.vfo.digital/2020.2008.24.400/63872E2D-666C-484F-94EB-F64B1F776A73/J2020.2008.24.400-Offline-x86.exe'
$checksum32     = '5654b2fefffda0e1652e23dd87364bac50cbe14089060bc0dc1d8d7b35d75c23'
$checksumType32 = 'sha256'
$url64          = 'http://jaws2020.vfo.digital/2020.2008.24.400/63872E2D-666C-484F-94EB-F64B1F776A73/J2020.2008.24.400-Offline-x64.exe'
$checksum64     = '33be41686457400b6df8c67e7969163d78140e86a97fa62bb26818a1d032b4e0'
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

