$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.igniterealtime.org/downloadServlet?filename=spark/spark_2_9_4-with-jre.exe'
$checksum     = '339c54452c104314126d1344c71e2b487c6f91abba6c5038896eee5be19b99ba'
$checksumType = 'sha256'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName   = 'Spark*'
  silentArgs     = '-q'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
