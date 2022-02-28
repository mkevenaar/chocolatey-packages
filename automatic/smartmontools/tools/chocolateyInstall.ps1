$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://sourceforge.net/projects/smartmontools/files/smartmontools/7.3/smartmontools-7.3-1.win32-setup.exe/download'
$checksum     = '6fcdfd72f486f74700810ff1b8016ec842a3495990f356c2f76b984cbbc89e2a'
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
