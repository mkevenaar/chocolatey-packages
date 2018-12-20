$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.almico.com/speedfan452.exe'
$checksum     = 'e2ccb3c0d23f0d04ee8057f5ce3861eea952fb20694c1656c9805b1d4cd922ff'
$checksumType = 'sha256'

$options = @{
  Headers = @{
    Referer = 'http://www.almico.com/sfdownload.php';
  }
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName   = 'SpeedFan*'
  silentArgs     = '/S'
  options        = $options
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
