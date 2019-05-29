$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10059/'
$checksum32     = 'b80f2070513025e9cc72c3ee12f84002eb8f1239f4df364a9148c14df9aef1de'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10061/'
$checksum64     = 'f799a0214d6ecad394783bada43215a2358a87b8acc9382f2354f514579f8ca3'
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
  softwareName  = 'Bacula*'
  silentArgs    = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

