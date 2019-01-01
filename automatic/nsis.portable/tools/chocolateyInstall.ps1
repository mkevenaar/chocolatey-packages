$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://versaweb.dl.sourceforge.net/project/nsis/NSIS%203/3.04/nsis-3.04.zip'
$checksum     = '22f3349fea453a45551745635c13e5efb7849ecbdce709daa2b2fa8e2ac55fc4'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs
