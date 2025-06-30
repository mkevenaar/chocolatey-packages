$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_0_1.exe'
$checksum32     = 'ad82c41c96ee0e16209b0c2d65f80d3b62ce58b76fdab7bd84435f25814b0c3f'
$checksumType32 = 'sha256'
$url64          = 'https://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_5_0_1_x64.exe'
$checksum64     = '65e78936e051b52257f02f37f42271b358a7d1ab7775f9f4cf80837593887fb7'
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
