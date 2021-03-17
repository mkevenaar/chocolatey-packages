$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://exiftool.org/exiftool-12.22.zip'
$checksum     = '5c55863d141ffa7707c830cc254c09feccc61e13f45b652d35871715ab983b96'
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
