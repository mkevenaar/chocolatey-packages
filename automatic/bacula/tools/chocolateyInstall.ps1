$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.bacula.org/download/10871/'
$checksum32     = 'afd5f4ecdfb099b9902e0e171983e74595bf3cf8626a0356524005014ee9a832'
$checksumType32 = 'sha256'
$url64          = 'https://www.bacula.org/download/10873/'
$checksum64     = 'a45f4f09de862b02ca1e45c69d266c2b4e1e4c4620214addae53216ec574df85'
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

