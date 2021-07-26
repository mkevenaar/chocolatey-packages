$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://github.com/fttx/barcode-to-pc-server/releases/download/v3.17.0/barcode-to-pc-server.v3.17.0.win.setup.exe'
$checksum32     = '104667036cb93adc0a91314a15a26782cffbdca66394ca90ea104158368a5a2f'
$checksumType32 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  softwareName  = 'Barcode to PC server*'
  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

