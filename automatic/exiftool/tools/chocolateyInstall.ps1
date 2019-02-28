$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://owl.phy.queensu.ca/~phil/exiftool/exiftool-11.29.zip'
$checksum     = '75f79265099316616ad4bc307b409fd467c2058eb4618379d719d2f5ad0770fe'
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
