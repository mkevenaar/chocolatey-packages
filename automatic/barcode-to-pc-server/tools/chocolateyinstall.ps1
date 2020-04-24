$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://github.com/fttx/barcode-to-pc-server/releases/download/v3.8.0/barcode-to-pc-server.v3.8.0.win.setup.exe'
$checksum32     = 'f196fa4fc2a1d5a1d4a64438358756b8d2b5181e9591b4fb5f1d283438b77190'
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

