$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://github.com/fttx/barcode-to-pc-server/releases/download/v3.3.0/barcode-to-pc-server.v3.3.0.win.setup.exe'
$checksum32     = 'd3ebd65e89da4fdf8b45d3b407d89ce918aa17dac300b439bc58b30b999d890b'
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

