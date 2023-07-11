$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
$checksum32     = 'cd8ec66cc6c0558d2b0b7444e6c861546b3ea40671a2ea4e8117e3e9bcc3a28e'
$checksumType32 = 'sha256'
$url64          = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'
$checksum64     = '1b517e27084aa2b81e4b0f4c81170f0bef90578d29b3b594e781e169204ba086'
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

