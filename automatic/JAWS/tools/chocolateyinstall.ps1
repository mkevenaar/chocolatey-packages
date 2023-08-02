$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://jaws2023.vfo.digital/2023.2307.37.400/1692F978-666B-4364-B8DA-F82D64964061/J2023.2307.37.400-Offline-x64.exe'
$checksum64     = 'c63fe29eace3649d18fba23c7bc794676c720c5c758206e00e0bda7261de2d72'
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

