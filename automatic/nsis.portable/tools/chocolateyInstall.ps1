$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://cfhcable.dl.sourceforge.net/project/nsis/NSIS%203/3.05/nsis-3.05.zip'
$checksum     = '3280c579b767a27b9bf53c17696cba550aed439d32fac972fe4469c97b198873'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs
