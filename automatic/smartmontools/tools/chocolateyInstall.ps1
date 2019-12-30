$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://sourceforge.net/projects/smartmontools/files/smartmontools/7.1/smartmontools-7.1-1.win32-setup.exe/download'
$checksum     = '7652f42bcd2997cbd5489435fd26e4cd708ed6ac20959418c8abf0993f37d827'
$checksumType = 'sha256'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName   = 'smartmontools*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
