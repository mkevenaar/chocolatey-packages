$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10823/'
$checksum32     = '073b372146cbd9668d75bd499cf81a572f6868d921d2f25a7ebf4b7ea0c7cf85'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10825/'
$checksum64     = '45868005cd7a3cde11a9982e02105708638be9ee3c36864ce2549a42ecd7861d'
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

