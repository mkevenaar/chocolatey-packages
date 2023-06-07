$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
$checksum32     = 'b408b34fe39ce4a993004aff099ea5e6c68ce9d6d4ab62b966d8d36c9d42fbd9'
$checksumType32 = 'sha256'
$url64          = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'
$checksum64     = 'f195f4a364066a1a841637de8497cb4dd5a405ac4af36172b7fd0ca80992584b'
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

