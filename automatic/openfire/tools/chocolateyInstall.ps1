$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_1_1.exe'
$checksum32     = '68b69309f22435e4996b18b21a451d8c3b98a543aa8680436694bf4a235b8299'
$checksumType32 = 'sha256'
$url64          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_1_1_x64.exe'
$checksum64     = 'b55659388274deedde92813ed830e1060c89b48fc3d61e6227c153bd4d96b57e'
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
