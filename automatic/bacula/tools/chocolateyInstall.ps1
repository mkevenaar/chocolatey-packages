$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10623/'
$checksum32     = '338d171b0174b7d08caf7f482ed80bafbd222442f456a28962bfa29959c68c32'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10625/'
$checksum64     = 'ae67e46142f2f96e478fd708d5e1b7ab250349a1c15faebe0c620b51bde9af80'
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

