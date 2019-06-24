$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://owl.phy.queensu.ca/~phil/exiftool/exiftool-11.53.zip'
$checksum     = '30899cb8d11cdbb20f34186072c7c2f5e581681875f9e4829b884848dd04810f'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

Move-Item "$(Join-Path $toolsDir 'exiftool(-k).exe')" "$(Join-Path $toolsDir 'exiftool.exe')" -Force
