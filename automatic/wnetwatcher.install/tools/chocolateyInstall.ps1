$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.nirsoft.net/utils/wnetwatcher_setup.exe'
$checksum     = '275a0bbc74b1ebb6bd53e2bb18fdbb9e5f7162b47a944bdaf4d5b893b9ee3a0a'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName   = 'Nirsoft wnetwatcher*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
