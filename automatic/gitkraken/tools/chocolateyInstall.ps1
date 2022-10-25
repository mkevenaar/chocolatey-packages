$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
$checksum32     = 'd0f738db4608ad1497e2dffa8a7ec0940720df1510341a5df5fc1df453e5f121'
$checksumType32 = 'sha256'
$url64          = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'
$checksum64     = '29e2fdbcb16ff26deb578f2f520fac459038bcd97a82c0c152b51e402578011e'
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

