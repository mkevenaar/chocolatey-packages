$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_1_2.exe'
$checksum32     = 'b32e33bc0e5305dcac308a82447f970b59a095f1edbb425d81ac93203db2f667'
$checksumType32 = 'sha256'
$url64          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_1_2_x64.exe'
$checksum64     = '5e52d57fb9e20235ed31a6809c3ecd139fb6583c0b24575cab3459ad4ff0b0a1'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'OpenFire*'
  silentArgs     = '-q'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
