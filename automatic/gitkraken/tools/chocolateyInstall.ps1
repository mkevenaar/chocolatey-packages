$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
$checksum32     = '45502ec54558d5205045120be204c89e8936a286ad84778945c876240e9a4cae'
$checksumType32 = 'sha256'
$url64          = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'
$checksum64     = 'a36f434d14524775d669f61cdb97cc16e43361a27ce62603c6f03f1b1d1e92e3'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe' #only one of these: exe, msi, msu
  url            = $url32
  checksum       = $checksum32
  checksumType   = $checksumType32
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  silentArgs   = '-s'
  validExitCodes= @(0) #please insert other valid exit codes here
  softwareName  = 'GitKraken*'
}

Install-ChocolateyPackage @packageArgs

