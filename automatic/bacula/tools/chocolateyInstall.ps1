$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10540/'
$checksum32     = 'dbba71c9531d1204d47be3b2045d4901df50c0bb54fb787225a8431d10606b57'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10543/'
$checksum64     = 'ed15a1e6b88fa8d061c3b64ae9d6a4acc235c7e9cae196ba99a120c63efc5ef4'
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

