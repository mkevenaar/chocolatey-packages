$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://sourceforge.net/projects/smartmontools/files/smartmontools/7.4/smartmontools-7.4-1.win32-setup.exe/download'
$checksum     = '76880e7303403667739066782b1c458ede2b4462a8ebd6aeacf97efecd4bdde7'
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
