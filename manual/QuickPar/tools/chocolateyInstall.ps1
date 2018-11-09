$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'http://download.quickpar.org.uk/download.php/QuickPar-0.9.1.0.exe'
$checksum     = '074a9f11057821228bfcc9531b2921d482bb76bfd70a29fda53b36c71c12e8e1'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType       = 'exe'
  url           = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'MySQL Workbench*'
  silentArgs = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
