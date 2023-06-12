$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
$checksum32     = '4b00e81092726791e8a1ba6309a202afeb11bb9787e244503b132d130a94da6d'
$checksumType32 = 'sha256'
$url64          = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'
$checksum64     = '8cca674f603f21f57355b1fa4e09517ae8661b2f1b5cea0f1a9819dff63165c7'
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

