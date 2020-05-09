$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://github.com/fttx/barcode-to-pc-server/releases/download/v3.9.0/barcode-to-pc-server.v3.9.0.win.setup.exe'
$checksum32     = '6d8f26ce70c03c62872de6b64fdad3c74de80efbc4e97dfd9fe34a5bf8de7a44'
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

