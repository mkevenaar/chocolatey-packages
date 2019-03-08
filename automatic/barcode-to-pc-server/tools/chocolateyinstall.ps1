$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://github.com/fttx/barcode-to-pc-server/releases/download/v3.0.2/barcode-to-pc-server.v3.0.2.win.setup.exe'
$checksum32     = '8cf7612445d56901ae6682556db80b386c5c117d0b565b70059044f18cb56386'
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

