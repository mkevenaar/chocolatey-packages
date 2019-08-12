$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.ceruleanstudios.com/trillian-v6.2.0.11.msi'
$checksum     = 'fc765c615105fd19a5158cd6d1244cb02814268fdc8f4e785684a0620c312d04'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Trillian*'
  silentArgs     = "/quiet /qn /norestart"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
