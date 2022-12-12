$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.igniterealtime.org/downloadServlet?filename=spark/spark_3_0_1-with-jre.exe'
$checksum     = 'bf9ba305aaf5e763eca5fc8332c73b5c155b49e03a28c5352777aa577bf66a41'
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
